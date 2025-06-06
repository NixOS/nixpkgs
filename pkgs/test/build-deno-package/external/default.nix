{ fetchFromGitHub, buildDenoPackage }:
{
  readma-cli-linux = buildDenoPackage rec {
    pname = "readma-cli";
    version = "2.11.0";
    denoDepsHash = "sha256-ixet3k6OEWfxVnN/V7vk4qDvoXjA+6bU/JjXk76aThE=";
    src = fetchFromGitHub {
      owner = "elcoosp";
      repo = "readma";
      rev = "${version}";
      hash = "sha256-FVQTn+r7Ztj02vNvqFZIRIsokWeo1tPfFYffK2tvxjA=";
    };
    denoInstallFlags = [
      "--allow-scripts"
      "--frozen"
      "--cached-only"
      "--entrypoint"
      "./cli/mod.ts"
    ];
    binaryEntrypointPath = "./cli/mod.ts";
    targetSystem = "x86_64-linux";
  };
  fresh-init-cli-linux = buildDenoPackage {
    pname = "fresh-init-cli";
    version = "";
    denoDepsHash = "sha256-WlMv431qTt3gw0w/V7lG8LnLkEt8VW1fNpyclzBwMcw=";
    src = fetchFromGitHub {
      owner = "denoland";
      repo = "fresh";
      rev = "c7c341b695bad8d0f3e3575e5fa9c82e0fa28bd4";
      hash = "sha256-bC4akr4Wt4sRqGkgjNuXztW8Q6YBLBsbuIOhsXH8NQU=";
    };
    denoWorkspacePath = "./init";
    binaryEntrypointPath = "./src/mod.ts";
    targetSystem = "x86_64-linux";
  };
  invidious-companion-cli-linux = buildDenoPackage {
    pname = "invidious-companion-cli";
    version = "";
    denoDepsHash = "sha256-sPcvVaVb4VsLI87kiYe3Z3eoXL1uDKwTQMck91cXVnM=";
    src = fetchFromGitHub {
      owner = "iv-org";
      repo = "invidious-companion";
      rev = "a34c27ff63e51f9e3adc0e8647cd12382f8f1ffe";
      hash = "sha256-/S8F7G8li12k0objsdFuh+mle6p2mk8zNUUCrG9hgns=";
    };
    binaryEntrypointPath = "src/main.ts";
    denoCompileFlags = [
      "--include=./src/lib/helpers/youtubePlayerReq.ts"
      "--include=./src/lib/helpers/getFetchClient.ts"
      "--allow-import=github.com:443,jsr.io:443,cdn.jsdelivr.net:443,esm.sh:443,deno.land:443"
      "--allow-net"
      "--allow-env"
      "--allow-read"
      "--allow-sys=hostname"
      "--allow-write=/var/tmp/youtubei.js"
    ];
    denoInstallFlags = [
      "--allow-scripts"
      "--frozen"
      "--cached-only"
      "--entrypoint"
      "src/main.ts"
    ];
    targetSystem = "x86_64-linux";
  };
}
