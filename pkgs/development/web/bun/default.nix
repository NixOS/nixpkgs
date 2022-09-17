{ stdenvNoCC, callPackage, fetchurl, autoPatchelfHook, unzip, openssl, lib }:
let
  dists = {
    aarch64-darwin = {
      arch = "aarch64";
      shortName = "darwin";
      sha256 = "sha256-R17Ga4C6PSxfL1bz6IBjx0dYFmX93i0y8uqxG1eZKd4=";
    };

    aarch64-linux = {
      arch = "aarch64";
      shortName = "linux";
      sha256 = "sha256-KSC4gdsJZJoPjMEs+VigVuqlUDhg4sL054WRlAbB+eA=";
    };

    x86_64-darwin = {
      arch = "x64";
      shortName = "darwin";
      sha256 = "sha256-CVqFPvZScNTudE2wgUctwGDgTyaMeN8dUNmLatcKo5M=";
    };

    x86_64-linux = {
      arch = "x64";
      shortName = "linux";
      sha256 = "sha256-N3hGPyp9wvb7jjpaFLJcdNIRyLvegjAe+MiV2aMS1nE=";
    };
  };
  dist = dists.${stdenvNoCC.hostPlatform.system} or (throw "Unsupported system: ${stdenvNoCC.hostPlatform.system}");
in
stdenvNoCC.mkDerivation rec {
  version = "0.1.11";
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
