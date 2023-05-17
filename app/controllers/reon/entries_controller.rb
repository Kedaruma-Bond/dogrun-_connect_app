class Reon::EntriesController < Reon::DogrunPlaceController
  include Pagy::Backend
  before_action :set_new_post, only: %i[index search]
  before_action :set_dogs_and_registration_numbers_at_local, only: %i[create update]
  before_action :set_q, only: %i[index search]
  before_action :correct_user_check, only: %i[destroy]

  def index
    @pagy, @entries = pagy(@entries)
  end

  def create
    if @dogrun_place.closed_flag == true
      redirect_to send(@top_path), error: t('local.entries.dogrun_is_closing_now')
      return
    end

    if not_pre_entry?
      @entries_array = []
      clear_zero
      select_dogs_allocation(params[:select_dog])
      
      case params[:pre_flg]
      when "0"
        while @num <= @select_dogs_values.count - 1
          @dog = @dogs[@num]
          
          if Entry.where(dog: @dog).where(exit_at: nil).present?
            set_num_of_playing_dogs
            respond_to do |format|
              format.html { redirect_to send(@top_path), error: t('local.entries.select_dog_has_already_entered') }
              format.turbo_stream { flash.now[:error] = t('local.entries.select_dog_has_already_entered') }
            end
            return
          end
          
          @registration_number = @registration_numbers[@num]
          
          case @select_dogs_values[@num]
          when '1'
            @entries_array[@num] = Entry.new(entry_params)
            @entries_array[@num].entry_at = Time.zone.now
            @entries_array[@num].save!

            @entry = @entries_array[@num]
            if @entry.dog.public_view?
              @entry.entry_broadcast(@entry.dog, current_user, @dogrun_place, @dog_profile_path)
            end
          else
            @zero_count += 1
            @entries_array[@num] = nil
          end
          @num += 1
        end

        if @dogs.count == @zero_count
          set_num_of_playing_dogs
          respond_to do |format|
            format.html { redirect_to send(@top_path), error: t('local.entries.select_entry_dog') }
            format.turbo_stream { flash.now[:error] = t('local.entries.select_entry_dog') }
          end
        else
          @entry_for_time = Entry.user_id_at_local(current_user.id).where(registration_numbers: { dogrun_place: @dogrun_place }).find_by(exit_at: nil) unless not_entry?(current_user, @dogrun_place)
          set_num_of_playing_dogs

          @entry.update_broadcast(@num_of_playing_dogs, @dogs_non_public)
          respond_to do |format|
            format.html { redirect_to send(@top_path), success: t('local.entries.entry_success') }
            format.turbo_stream { flash.now[:success] = t('local.entries.entry_success') }
          end
        end
      when "1"
        while @num <= @select_dogs_values.count - 1
          @dog = @dogs[@num]

          if PreEntry.where(dog: @dog).present?
            respond_to do |format|
              format.html { redirect_to send(@top_path), error: t('local.entries.select_dog_has_already_pre_entered') }
              format.turbo_stream { flash.now[:error] = t('local.entries.select_dog_has_already_pre_entered') }
            end
            return
          end

          @registration_number = @registration_numbers[@num]
          case @select_dogs_values[@num]
          when '1'
            @entries_array[@num] = PreEntry.new(pre_entry_params)
            @entries_array[@num].save!
            if @entries_array[@num].dog.public_view?
              @entries_array[@num].pre_entry_broadcast(@entries_array[@num].dog, current_user, @dogrun_place, @dog_profile_path)
            end
          else
            @zero_count += 1
            @entries_array[@num] = nil
          end
          @num += 1
        end

        if @dogs.count == @zero_count
          set_num_of_playing_dogs
          respond_to do |format|
            format.html { redirect_to send(@top_path), error: t('local.entries.select_pre_entry_dog') }
            format.turbo_stream { flash.now[:error] = t('local.entries.select_pre_entry_dog') }
          end
        else
          respond_to do |format|
            format.html { redirect_to send(@top_path), success: t('local.entries.pre_entry_success') }
            format.turbo_stream { flash.now[:success] = t('local.entries.pre_entry_success') }
          end
        end
      end
    else
      current_pre_entries
      @current_pre_entries.each do |pre_entry|
        @entry = Entry.create(dog: pre_entry.dog, 
          registration_number: pre_entry.registration_number,
          entry_at: Time.zone.now)
        if @entry.dog.public_view?
          @entry.entry_broadcast(@entry.dog, current_user, @dogrun_place, @dog_profile_path)
        end
        pre_entry.destroy
      end
      @entry_for_time = Entry.user_id_at_local(current_user.id).where(registration_numbers: { dogrun_place: @dogrun_place }).find_by(exit_at: nil) unless not_entry?(current_user, @dogrun_place)
      set_num_of_playing_dogs

      @entry.update_broadcast(@num_of_playing_dogs, @dogs_non_public)
      respond_to do |format|
        format.html { redirect_to send(@top_path), success: t('local.entries.entry_success') }
        format.turbo_stream { flash.now[:success] = t('local.entries.entry_success') }
      end
    end
  end

  def update
    if current_entries.blank?
      redirect_to send(@top_path), success: t('local.entries.exit_success')
      return
    end

    i = current_entries.size - 1
    @entry = current_entries[i]
    current_entries.each do |entry|
      Entry.find(entry.id).update(exit_at: Time.zone.now)
    end
    set_num_of_playing_dogs

    @entry.update_broadcast(@num_of_playing_dogs, @dogs_non_public)

    respond_to do |format|
      format.html { redirect_to send(@top_path), success: t('local.entries.exit_success') }
      format.turbo_stream { flash.now[:success] = t('local.entries.exit_success') }
    end
  end

  def search
    @pagy, @entries_results = pagy(@q.result)
  end

  def destroy
    @entry.destroy
    set_num_of_playing_dogs
    @entry.update_broadcast(@num_of_playing_dogs, @dogs_non_public)
    respond_to do |format|
      format.html { redirect_to send(@entries_path), success: t('defaults.destroy_successfully'), status: :see_other }
      format.turbo_stream { flash.now[:success] = t('defaults.destroy_successfully') }
    end
  end

  private

    def set_q
      @entries = Entry.includes(:registration_number, :dog).where(registration_number: { dogrun_place: @dogrun_place }).where(dogs: { public: "public_view" } ).order(entry_at: :desc)
      @q = @entries.ransack(params[:q])
    end

    def entry_params
      params.permit(
        :dog_id, :registration_number_id,
        :entry_at, :exit_at,
        :select_dog
      ).merge(
        dog_id: @dog.id,
        registration_number_id: @registration_number.id
      )
    end

    def pre_entry_params
      params.permit(
        :dog_id, :registration_number_id,
        :minutes_passed_count
      ).merge(
        dog_id: @dog.id,
        registration_number_id: @registration_number.id
      )
    end

    def correct_user_check
      @entry = Entry.find(params[:id])
      redirect_to send(@entries_path), error: t('defaults.not_authorized') unless @entry.dog.user == current_user
    end
    
end
