"use strict";

const childProcess = require("child_process");
const fs = require("fs");

const [playwrightCorePath, expectedConfigPath] = process.argv.slice(2);

if (!playwrightCorePath || !expectedConfigPath) {
  throw new Error("usage: browser-downloads-test.js <playwright-core> <expected-config>");
}

const browserDownloads = JSON.parse(fs.readFileSync(expectedConfigPath, "utf8"));
const browserNames = Object.keys(browserDownloads);

const hostPlatformBySystem = {
  "x86_64-linux": "ubuntu24.04-x64",
  "aarch64-linux": "ubuntu24.04-arm64",
  "x86_64-darwin": "mac15",
  "aarch64-darwin": "mac15-arm64",
};

function getRegistryDownloadURLs(hostPlatform) {
  const script = `
    const path = require("path");
    const { registry } = require(path.join(process.env.PLAYWRIGHT_CORE_PATH, "lib/server/registry/index.js"));
    const browserNames = JSON.parse(process.env.PLAYWRIGHT_BROWSER_NAMES);
    const downloadURLs = Object.fromEntries(
      browserNames.map((name) => [name, registry.findExecutable(name).downloadURLs]),
    );
    process.stdout.write(JSON.stringify(downloadURLs));
  `;

  return JSON.parse(
    childProcess.execFileSync(process.execPath, ["-e", script], {
      encoding: "utf8",
      env: {
        ...process.env,
        PLAYWRIGHT_BROWSER_NAMES: JSON.stringify(browserNames),
        PLAYWRIGHT_CORE_PATH: playwrightCorePath,
        PLAYWRIGHT_HOST_PLATFORM_OVERRIDE: hostPlatform,
      },
    }),
  );
}

const failures = [];
const systems = Object.keys(browserDownloads[browserNames[0]]);

for (const system of systems) {
  const hostPlatform = hostPlatformBySystem[system];
  const registryDownloadURLs = getRegistryDownloadURLs(hostPlatform);

  if (!hostPlatform) {
    throw new Error(`unsupported system: ${system}`);
  }

  for (const name of browserNames) {
    const expectedDownload = browserDownloads[name][system];
    const actualDownloadURLs = registryDownloadURLs[name];

    if (!expectedDownload) {
      failures.push(`missing browser-downloads.nix entry for ${name} on ${system}`);
      continue;
    }

    if (!Array.isArray(actualDownloadURLs) || actualDownloadURLs.length === 0) {
      failures.push(`missing registry download URLs for ${name} on ${system} (${hostPlatform})`);
      continue;
    }

    const actualDownloadURL = actualDownloadURLs[0];

    if (expectedDownload.url !== actualDownloadURL) {
      failures.push(
        [
          `${name} on ${system} (${hostPlatform}) did not match Playwright's primary download URL`,
          `expected: ${browserDownloads[name][system].url}`,
          `registry: ${actualDownloadURL}`,
        ].join("\n"),
      );
    }
  }
}

if (failures.length > 0) {
  console.error("Playwright browser download URL mismatches:");
  for (const failure of failures) {
    console.error(`- ${failure}`);
  }
  process.exit(1);
}
