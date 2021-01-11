let path = require("path");
const HtmlWebpackPlugin = require("html-webpack-plugin");
let elmSource = __dirname

module.exports = {
    entry : [
      "./src/index.js"
    ],
    module : {
        rules: [{
            test: /\.elm$/,
            exclude: [/elm-stuff/, /node_modules/],
            use: {
                loader: "elm-webpack-loader",
                options: {
                    cwd: elmSource
                }
            }
        }]
    },
    plugins: [
        new HtmlWebpackPlugin({
            title: "IO.inspect(独り言)"
        })
    ]
};