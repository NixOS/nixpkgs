{ stdenvNoCC, callPackage, fetchurl, autoPatchelfHook, unzip, openssl, lib }:
let
  dists = {
    aarch64-darwin = {
      arch = "aarch64";
      shortName = "darwin";
      sha256 = "c82547d96125bf93ae76dafe203cae5f7cd50d041bfb1cf972f9f0232a0d1cc1";
    };

    aarch64-linux = {
      arch = "aarch64";
      shortName = "linux";
      sha256 = "3430f3ff456ee86ddb607a46ee937c9c1a02b8e4d2546de52b4493878f66afb8";
    };

    x86_64-darwin = {
      arch = "x64";
      shortName = "darwin";
      sha256 = "51fb5f29b5f00207ede11c892ccf5bb3ab437b77e7420e1c18b7fc91e02e2494";
    };

    x86_64-linux = {
      arch = "x64";
      shortName = "linux";
      sha256 = "89fe00713a4e0e9f77d8842c5e07f771bd743271746fcb755c5d98cb5c00456e";
    };
  };
  dist = dists.${stdenvNoCC.hostPlatform.system} or (throw "Unsupported system: ${stdenvNoCC.hostPlatform.system}");
in
stdenvNoCC.mkDerivation rec {
  version = "0.1.6";
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
