{ lib
, stdenvNoCC
, callPackage
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
  version = "0.2.2";
  pname = "bun";

  src = passthru.sources.${stdenvNoCC.hostPlatform.system} or (throw "Unsupported system: ${stdenvNoCC.hostPlatform.system}");

  strictDeps = true;
  nativeBuildInputs = [ unzip ] ++ lib.optionals stdenvNoCC.isLinux [ autoPatchelfHook ];
  buildInputs = [ openssl ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    install -Dm 755 ./bun $out/bin/bun
    runHook postInstall
  '';
  passthru = {
    sources = {
      "aarch64-darwin" = fetchurl {
        url = "https://github.com/oven-sh/bun/releases/download/bun-v${version}/bun-darwin-aarch64.zip";
        sha256 = "IIy5ZEx/+StAhtRcGqM3uvvEqu4wGzGUls0K/ot4jRI=";
      };
      "aarch64-linux" = fetchurl {
        url = "https://github.com/oven-sh/bun/releases/download/bun-v${version}/bun-linux-aarch64.zip";
        sha256 = "5cScLXujNm14+SCr8OcO93RDL3EfAjsuAzfcwj+EMKs=";
      };
      "x86_64-darwin" = fetchurl {
        url = "https://github.com/oven-sh/bun/releases/download/bun-v${version}/bun-darwin-x64.zip";
        sha256 = "3PdLVz4qTJQHmM9laL413xnZaSuD6xlaSy8cuJ9M8us=";
      };
      "x86_64-linux" = fetchurl {
        url = "https://github.com/oven-sh/bun/releases/download/bun-v${version}/bun-linux-x64.zip";
        sha256 = "eVEopSvyjzY8J3q52wowTlSVHZ4s1lIc8/yU6Ya+0QU=";
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
    changelog = "https://github.com/Jarred-Sumner/bun/releases/tag/bun-v${version}";
    description = "Incredibly fast JavaScript runtime, bundler, transpiler and package manager – all in one";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    longDescription = ''
      All in one fast & easy-to-use tool. Instead of 1,000 node_modules for development, you only need bun.
    '';
    license = with licenses; [
      mit # bun core
      lgpl21Only # javascriptcore and webkit
    ];
    maintainers = with maintainers; [ DAlperin jk ];
    platforms = builtins.attrNames passthru.sources;
  };
}
