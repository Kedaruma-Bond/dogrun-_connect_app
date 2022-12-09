const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  content: [
    './public/*.html',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*.{erb,haml,html,slim}'
  ],
  theme: {
    screens: {
      'sm': '640px',
      // => @media (min-width: 640px) { ... }

      'md': '768px',
      // => @media (min-width: 768px) { ... }

      'lg': '1024px',
      // => @media (min-width: 1024px) { ... }

      'xl': '1280px',
      // => @media (min-width: 1280px) { ... }

      '2xl': '1536px',
      // => @media (min-width: 1536px) { ... }
    },
    extend: {
      fontFamily: {
        sans: ['Inter var', ...defaultTheme.fontFamily.sans],
      },
      keyframes: {
        "fade-in": {
          '0%': { opacity: '0%' },
          '100%': { opacity: '100%' },
        },
        "scale-in-ver-top": {
          "0%": {
              transform: "scaleY(0)",
              "transform-origin": "100% 0%",
              opacity: "1"
          },
          to: {
              transform: "scaleY(1)",
              "transform-origin": "100% 0%",
              opacity: "1"
          }
        },
        "scale-out-ver-top": {
          "0%": {
              transform: "scaleY(1)",
              "transform-origin": "100% 0%",
              opacity: "1"
          },
          to: {
              transform: "scaleY(0)",
              "transform-origin": "100% 0%",
              opacity: "1"
          }
        }
      },
      animation: {
        "fade-in": 'fade-in 0.5s ease-in-out',
        "scale-in-ver-top": "scale-in-ver-top 0.1s cubic-bezier(0.250, 0.460, 0.450, 0.940)   both",
        "scale-out-ver-top": "scale-out-ver-top 0.1s cubic-bezier(0.550, 0.085, 0.680, 0.530)   both"
      }
    },
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/typography'),
  ]
}
