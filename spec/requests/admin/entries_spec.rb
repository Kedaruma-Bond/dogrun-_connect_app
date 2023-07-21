require 'rails_helper'

RSpec.describe Admin::EntriesController, type: :request do
  let!(:dogrun_place_1) { create(:dogrun_place, :togo_inu_shitsuke_hiroba) }
  let!(:dogrun_place_2) { create(:dogrun_place, :reon) }
  let!(:admin_1) { create(:user, :admin, dogrun_place: dogrun_place_1) }
  let!(:general) { create(:user, :general) }
  let!(:dog_1) { create(:dog, :castrated, :public_view, user: general) }
  let!(:dog_2) { create(:dog, :castrated, :public_view, user: general) }
  let!(:registration_number_1) { create(:registration_number, dog: dog_1, dogrun_place: dogrun_place_1)}
  let!(:registration_number_2) { create(:registration_number, dog: dog_2, dogrun_place: dogrun_place_2)}
  let!(:entry_1) { create(:entry, dog: dog_1, registration_number: registration_number_1) }
  let!(:entry_2) { create(:entry, dog: dog_2, registration_number: registration_number_2) }

  describe 'GET #index' do
    context '管理者ユーザーでログインしているとき' do
      before do
        admin_log_in_as(admin_1)
        get admin_entries_path
      end

      example '正常なレスポンスが返ること' do
        expect(response).to be_successful
      end

      example '正しい入場記録が表示されること' do
        expect(assigns(:entries)).to include(entry_1)
        expect(assigns(:entries)).not_to include(entry_2)
      end
    end

    context '一般ユーザーでログインしているとき' do
      before do
        admin_log_in_as(general)
        get admin_entries_path
      end

      example 'エラーメッセージが表示されてhome画面にリダイレクトされること' do
        expect(flash[:error]).to eq(I18n.t('defaults.not_authorized'))
        expect(response).to redirect_to(root_path)
      end
    end
    
    context 'ログインしていないとき' do
      before do
        get admin_entries_path
      end

      example 'エラーメッセージが表示されて管理者ログイン画面にリダイレクトされること' do
        expect(flash[:error]).to eq(I18n.t('defaults.require_login'))
        expect(response).to redirect_to(admin_login_path)
      end
    end
  end

  describe 'PATCH #update' do
    let!(:entry_3) { create(:entry, :not_exit, dog: dog_1, registration_number: registration_number_1) }
    let!(:entry_4) { create(:entry, :not_exit, dog: dog_1, registration_number: registration_number_2) }
    describe '管理者ユーザーとしてログインしているとき' do
      before do
        admin_log_in_as(admin_1)
      end
      describe 'ログインしている管理者の該当ドッグランの記録を退場させる場合' do
        context 'params[:force_flg]が"1"の場合' do
          example '入場中の記録を強制退場して通知メールを送信しメッサージと共に前回表示していたページにリダイレクトされること' do
            patch admin_entry_path(entry_3), params: { force_flg: "1" }
            expect(entry_3.reload.exit_at).not_to eq(nil)
            expect(ActionMailer::Base.deliveries.count).to eq(1)
            expect(response).to redirect_to(admin_entries_path)
            expect(flash[:success]).to eq(I18n.t('admin.entries.update.force_exit_successfully'))
          end
        end
        
        context 'params[:force_flg]が"0"の場合' do
          example '入場中の記録を退場してメッサージと共に前回表示していたページにリダイレクトされること' do
            patch admin_entry_path(entry_3), params: { force_flg: "0" }
            expect(entry_3.reload.exit_at).not_to eq(nil)
            expect(ActionMailer::Base.deliveries.count).not_to eq(1)
            expect(response).to redirect_to(admin_entries_path)
            expect(flash[:success]).to eq(I18n.t('admin.entries.update.exit_successfully'))
          end
        end
      end

      describe 'ログインしている管理者とは別のドッグランの記録を退場させる場合' do
        example '退場できずエラーメッセージが表示され管理者home画面にリダイレクトされること' do
          patch admin_entry_path(entry_4)
          expect(flash[:error]).to eq(I18n.t('defaults.not_authorized'))
          expect(response).to redirect_to(admin_root_path)
        end
      end
    end

    context '一般ユーザーでログインしている時' do
      before do
        admin_log_in_as(general)
      end
      example 'エラーメッセージが表示されてhome画面にリダイレクトされること' do
        patch admin_entry_path(entry_3)
        expect(flash[:error]).to eq(I18n.t('defaults.not_authorized'))
        expect(response).to redirect_to(root_path)
      end
    end

    context 'ログインしていないとき' do
      example 'エラーメッセージが表示されて管理者ログイン画面にリダイレクトされること' do
        patch admin_entry_path(entry_3)
        expect(flash[:error]).to eq(I18n.t('defaults.require_login'))
        expect(response).to redirect_to(admin_login_path)
      end
    end
  end

  describe 'DELETE #destroy' do

    describe '管理者ユーザーでログインしているとき' do
      before do
        admin_log_in_as(admin_1)
      end
      context 'ログインしている管理者の該当ドッグランの記録削除する場合' do
        example '入場記録が削除され、メッセージと共に前回表示していたページをにリダイレクトされること' do
          expect {
            delete admin_entry_path(entry_1)
          }.to change { Entry.count }.by(-1)
          expect(response).to redirect_to(admin_entries_path) 
          expect(flash[:success]).to eq(I18n.t('defaults.destroy_successfully'))
        end
      end

      context 'ログインしている管理者とは別のドッグランの記録を削除する場合' do
        example '削除されずエラーメッセージが表示され管理者home画面にリダイレクトされること' do
          delete admin_entry_path(entry_2)
          expect(flash[:error]).to eq(I18n.t('defaults.not_authorized'))
          expect(response).to redirect_to(admin_root_path)
        end
      end
    end

    context '一般ユーザーでログインしているとき' do
      before do
        admin_log_in_as(general)
      end
      example 'エラーメッセージが表示されてhome画面にリダイレクトされること' do
        delete admin_entry_path(entry_1)
        expect(flash[:error]).to eq(I18n.t('defaults.not_authorized'))
        expect(response).to redirect_to(root_path)
      end
    end
    
    context 'ログインしていないとき' do
      example 'エラーメッセージが表示されて管理者ログイン画面にリダイレクトされること' do
        delete admin_entry_path(entry_1)
        expect(flash[:error]).to eq(I18n.t('defaults.require_login'))
        expect(response).to redirect_to(admin_login_path)
      end
    end
  end
end
