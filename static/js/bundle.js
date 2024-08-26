const { build } = require("esbuild");
const fs = require("fs");
const path = require("path");

async function bundleSubfolders() {
  const entryPoints = await getJavaScriptFiles("./static/js/src");

  for (const entryPoint of entryPoints) {
    const outputPath = entryPoint
      .replace("/src", "/dist")
      .replace(".js", ".min.js");

    await build({
      entryPoints: [entryPoint],
      bundle: true,
      outfile: outputPath,
      minify: true,
    });

    console.log(`Bundle created: ${outputPath}`);
  }
}

async function getJavaScriptFiles(directory) {
  const files = await fs.promises.readdir(directory, { withFileTypes: true });
  let jsFiles = [];

  for (const file of files) {
    const fullPath = path.join(directory, file.name);

    if (file.isDirectory()) {
      const nestedFiles = await getJavaScriptFiles(fullPath);
      jsFiles = jsFiles.concat(nestedFiles);
    } else if (file.isFile() && file.name.endsWith(".js")) {
      jsFiles.push(fullPath);
    }
  }

  return jsFiles;
}

bundleSubfolders().catch((err) => {
  console.error(err);
  process.exit(1);
});
