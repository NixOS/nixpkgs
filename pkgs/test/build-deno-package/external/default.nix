{ fetchFromGitHub, buildDenoPackage }:
{
  readma-cli-linux = buildDenoPackage rec {
    pname = "readma-cli";
    version = "2.11.0";
    denoDepsHash = "sha256-uh+yaT8oPMD0FRENH4LaoCsvbWmQ0j+xPbAL3e4Mfws=";
    src = fetchFromGitHub {
      owner = "elcoosp";
      repo = "readma";
      rev = "${version}";
      hash = "sha256-FVQTn+r7Ztj02vNvqFZIRIsokWeo1tPfFYffK2tvxjA=";
    };
    binaryEntrypointPath = "./cli/mod.ts";
    targetSystem = "x86_64-linux";
  };
  fresh-init-cli-linux = buildDenoPackage {
    pname = "fresh-init-cli";
    version = "";
    denoDepsHash = "sha256-ycSMUyY7xj+o9gIVwUWbcoN+5Gf27P2x0dFUmtWGGlQ=";
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
}
