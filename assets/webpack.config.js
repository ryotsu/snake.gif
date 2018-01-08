const autoprefixer = require('autoprefixer');
const path = require('path');
const webpack = require('webpack');
const CopyWebpackPlugin = require('copy-webpack-plugin');
const ExtractTextPlugin = require('extract-text-webpack-plugin');


const config = {
  bail: true,
  entry: ['./js/app.js', './re/app.re'],
  output: {
    path: path.resolve(__dirname, '../priv/static'),
    filename: 'js/app.js'
  },
  module: {
    rules: [{
      oneOf: [
        {
          test: /\.(js|jsx|mjs)$/,
          include: path.resolve(__dirname, "js"),
          loader: require.resolve('babel-loader'),
          options: {
            compact: true,
            presets: ['env']
          },
        },
        {
          test: /\.css$/,
          use: ExtractTextPlugin.extract({
            fallback: "style-loader",
            use: [
              {
                loader: require.resolve('css-loader'),
                options: {
                  importLoaders: 1,
                  minimize: true,
                },
              },
              {
                loader: require.resolve('postcss-loader'),
                options: {
                  // Necessary for external CSS imports to work
                  // https://github.com/facebookincubator/create-react-app/issues/2677
                  ident: 'postcss',
                  plugins: () => [
                    require('postcss-flexbugs-fixes'),
                    autoprefixer({
                      browsers: [
                        '>1%',
                        'last 4 versions',
                        'Firefox ESR',
                        'not ie < 9', // React doesn't support IE8 anyway
                      ],
                      flexbox: 'no-2009',
                    }),
                  ],
                },
              },
            ]
          })
        },
        {
          test: /\.(re|ml)$/,
          use: [{
            loader: 'bs-loader',
            options: {
              module: 'commonjs',
              inSource: false
            }
          }]
        }
      ]
    }]
  },
  plugins: [
    new webpack.optimize.UglifyJsPlugin({
      compress: {
        warnings: false,
        comparisons: false,
      },
      mangle: {
        safari10: true,
      },
      output: {
        comments: false,
        ascii_only: true,
      },
    }),

    new ExtractTextPlugin({
      filename: 'css/app.css',
    }),

    new CopyWebpackPlugin([{
      from: './static',
      to: './'
    }])
  ],

  resolve: {
    extensions: ['.re', '.ml', '.js']
  }
};

module.exports = config;
