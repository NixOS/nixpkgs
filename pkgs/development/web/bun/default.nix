{ stdenvNoCC, callPackage, fetchurl, autoPatchelfHook, unzip, openssl, lib }:
let
  dists = {
    aarch64-darwin = {
      arch = "aarch64";
      shortName = "darwin";
      sha256 = "06kf4dyb8y486r2bbpz8znnaxah9y2hwc9km3cigacfchi4dy28j";
    };

    x86_64-darwin = {
      arch = "x64";
      shortName = "darwin";
      sha256 = "06q8cajxra8lgyd1ap6iqzqdw31gkvlc6l2ma0mm22y63msgdn8b";
    };

    x86_64-linux = {
      arch = "x64";
      shortName = "linux";
      sha256 = "038w54yyk94042hg27hfm49w12xsg8wh0skza9l9iybvc9qlvh2i";
    };
  };
  dist = dists.${stdenvNoCC.hostPlatform.system} or (throw "Unsupported system: ${stdenvNoCC.hostPlatform.system}");
in
stdenvNoCC.mkDerivation rec {
  version = "0.1.1";
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
