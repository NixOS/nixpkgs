{ stdenvNoCC, callPackage, fetchurl, autoPatchelfHook, unzip, openssl, lib }:
let
  dists = {
    aarch64-darwin = {
      arch = "aarch64";
      shortName = "darwin";
      sha256 = "80304f6cf43c6be3db0303bdcb4de4995ace1a394ac6068bbe1e2b6fba32b2e5";
    };

    aarch64-linux = {
      arch = "aarch64";
      shortName = "linux";
      sha256 = "6b22b6221014fed9e6b6cb432505424e618ef095b2060945ad119cd8f2155fae";
    };

    x86_64-darwin = {
      arch = "x64";
      shortName = "darwin";
      sha256 = "33f4c420467af85584ba444606651a0352906c9135d952b266bb6da100ef95bf";
    };

    x86_64-linux = {
      arch = "x64";
      shortName = "linux";
      sha256 = "524a2d7e51ddda4786799552ae1c18ab8e6173bb30f158f26cae899a7e74f22f";
    };
  };
  dist = dists.${stdenvNoCC.hostPlatform.system} or (throw "Unsupported system: ${stdenvNoCC.hostPlatform.system}");
in
stdenvNoCC.mkDerivation rec {
  version = "0.1.5";
  pname = "bun";

  src = fetchurl {
    url = "https://github.com/Jarred-Sumner/bun-releases-for-updater/releases/download/bun-v${version}/bun-${dist.shortName}-${dist.arch}.zip";
    sha256 = dist.sha256;
  };

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
    platforms = builtins.attrNames dists;
  };
}
