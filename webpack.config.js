let path = require("path");
const HtmlWebpackPlugin = require("html-webpack-plugin");
const MiniCssExtractPlugin = require('mini-css-extract-plugin');
const HtmlWebpackTagsPlugin = require('html-webpack-tags-plugin');
const CopyPlugin = require("copy-webpack-plugin");
let elmSource = __dirname

module.exports = {
    entry : [
      "./src/js/index.js"
    ],
    module : {
        rules: [
            {
                test: /\.elm$/,
                exclude: [/elm-stuff/, /node_modules/],
                use: {
                    loader: "elm-webpack-loader",
                    options: {
                        cwd: elmSource
                    }
                }
            },
            {
                test: /\.css$/,
                exclude: "/node_modules/",
                use: [
                    {
                        loader: MiniCssExtractPlugin.loader
                    },
                    {
                        loader: 'css-loader',
                        options: {
                            importLoaders: 1,
                        }
                    },
                    {
                        loader: 'postcss-loader'
                    }
                ]
            }
        ]
    },
    plugins: [
        new MiniCssExtractPlugin(
        ),
        new CopyPlugin({
            patterns: [
                {from: "assets"}
            ],
        }),
        new HtmlWebpackTagsPlugin({
            append: false, scripts: ["highlight/highlight.pack.js"], links: ["highlight/default.css"]
        }),
        new HtmlWebpackPlugin({
            title: "IO.inspect(独り言)"
        })
    ]
};