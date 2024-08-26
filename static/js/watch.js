const chokidar = require("chokidar");
const { build } = require("esbuild");
const fs = require("fs/promises");
const path = require("path");

const srcDirectory = "./static/js/src";

chokidar
  .watch(srcDirectory, { recursive: true })
  .on("change", async (filePath) => {
    if (filePath.endsWith(".js")) {
      await minifyFile(filePath);
      console.log(`File ${filePath} has been minified.`);
    }
  });

async function minifyFile(filePath) {
  const outputPath = filePath
    .replace("/src", "/dist")
    .replace(".js", ".min.js");
  await build({
    entryPoints: [filePath],
    outfile: outputPath,
    minify: true,
  });
}

console.log(`Watching for changes in ${srcDirectory}...`);
