const path = require("path");

module.exports = {
  mode: "production",
  devtool: false,
  entry: "./dist/esm/index.js",
  resolve: {
    extensions: [".js"],
  },
  output: {
    path: path.resolve(__dirname, "dist/umd"),
    filename: "ffmpeg.js",
    library: "FFmpegWASM",
    libraryTarget: "umd",
  },
  stats: {
    warnings:false
  }
};
