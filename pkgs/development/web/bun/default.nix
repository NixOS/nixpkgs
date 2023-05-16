{ lib
, stdenvNoCC
<<<<<<< HEAD
=======
, callPackage
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, fetchurl
, autoPatchelfHook
, unzip
, openssl
, writeShellScript
, curl
, jq
, common-updater-scripts
}:

stdenvNoCC.mkDerivation rec {
<<<<<<< HEAD
  version = "1.0.0";
=======
  version = "0.5.9";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pname = "bun";

  src = passthru.sources.${stdenvNoCC.hostPlatform.system} or (throw "Unsupported system: ${stdenvNoCC.hostPlatform.system}");

  strictDeps = true;
  nativeBuildInputs = [ unzip ] ++ lib.optionals stdenvNoCC.isLinux [ autoPatchelfHook ];
  buildInputs = [ openssl ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
<<<<<<< HEAD

    install -Dm 755 ./bun $out/bin/bun
    ln -s $out/bin/bun $out/bin/bunx

=======
    install -Dm 755 ./bun $out/bin/bun
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    runHook postInstall
  '';
  passthru = {
    sources = {
      "aarch64-darwin" = fetchurl {
        url = "https://github.com/oven-sh/bun/releases/download/bun-v${version}/bun-darwin-aarch64.zip";
<<<<<<< HEAD
        hash = "sha256-Bd8KL1IbWBRiMZq4YPhNLdhBOqRReCFeUPAilLfk0TM=";
      };
      "aarch64-linux" = fetchurl {
        url = "https://github.com/oven-sh/bun/releases/download/bun-v${version}/bun-linux-aarch64.zip";
        hash = "sha256-CHOiQ47wXjkFyJG9ElE9gBpmWpylMEUf6c+Sm+YCpGc=";
      };
      "x86_64-darwin" = fetchurl {
        url = "https://github.com/oven-sh/bun/releases/download/bun-v${version}/bun-darwin-x64.zip";
        hash = "sha256-0AT58hjawS60q5YAQd/upVz0vOIs11JM+lc3c1mGyOE=";
      };
      "x86_64-linux" = fetchurl {
        url = "https://github.com/oven-sh/bun/releases/download/bun-v${version}/bun-linux-x64.zip";
        hash = "sha256-1ju7ZuW82wRfXEiU24Lx9spCoIhhddJ2p4dTTQmsa7A=";
=======
        sha256 = "nkXTyJMvGMBz1xiWudLSwl+s7gb750g1oYTvPoY+o0M=";
      };
      "aarch64-linux" = fetchurl {
        url = "https://github.com/oven-sh/bun/releases/download/bun-v${version}/bun-linux-aarch64.zip";
        sha256 = "pJXwRuokjlwVNLoDajvhIIBzLdYUHZsLxXr98RkC6Hg=";
      };
      "x86_64-darwin" = fetchurl {
        url = "https://github.com/oven-sh/bun/releases/download/bun-v${version}/bun-darwin-x64.zip";
        sha256 = "3vx61oBNS9K5kjAitIO3VJ6mVK4vpkAAn6Pur7ogsBA=";
      };
      "x86_64-linux" = fetchurl {
        url = "https://github.com/oven-sh/bun/releases/download/bun-v${version}/bun-linux-x64.zip";
        sha256 = "vwxkydYJdnb8MBUAfywpXdaahsuw5IvnXeoUmilzruE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    };
    updateScript = writeShellScript "update-bun" ''
      set -o errexit
      export PATH="${lib.makeBinPath [ curl jq common-updater-scripts ]}"
      NEW_VERSION=$(curl --silent https://api.github.com/repos/oven-sh/bun/releases/latest | jq '.tag_name | ltrimstr("bun-v")' --raw-output)
      if [[ "${version}" = "$NEW_VERSION" ]]; then
          echo "The new version same as the old version."
          exit 0
      fi
      for platform in ${lib.escapeShellArgs meta.platforms}; do
        update-source-version "bun" "0" "${lib.fakeSha256}" --source-key="sources.$platform"
        update-source-version "bun" "$NEW_VERSION" --source-key="sources.$platform"
      done
    '';
  };
  meta = with lib; {
    homepage = "https://bun.sh";
<<<<<<< HEAD
    changelog = "https://bun.sh/blog/bun-v1.0"; # 1.0 changelog does not use the full version name, please change this to ${version} in the following releases
=======
    changelog = "https://github.com/Jarred-Sumner/bun/releases/tag/bun-v${version}";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    description = "Incredibly fast JavaScript runtime, bundler, transpiler and package manager – all in one";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    longDescription = ''
      All in one fast & easy-to-use tool. Instead of 1,000 node_modules for development, you only need bun.
    '';
    license = with licenses; [
      mit # bun core
      lgpl21Only # javascriptcore and webkit
    ];
<<<<<<< HEAD
    maintainers = with maintainers; [ DAlperin jk thilobillerbeck cdmistman coffeeispower ];
=======
    maintainers = with maintainers; [ DAlperin jk ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    platforms = builtins.attrNames passthru.sources;
  };
}
