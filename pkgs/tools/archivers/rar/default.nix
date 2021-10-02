{ lib, stdenv, fetchurl, autoPatchelfHook, installShellFiles }:

let
  version = "6.0.2";
  srcUrl = {
    i686-linux = {
      url = "https://www.rarlab.com/rar/rarlinux-${version}.tar.gz";
      sha256 = "sha256-5iqk7eoo+hgltgscquob+wofzhuqz0m/8jf7bxdf9qa=";
    };
    x86_64-linux = {
      url = "https://www.rarlab.com/rar/rarlinux-x64-${version}.tar.gz";
      sha256 = "sha256-WAvrUGCgfwI51Mo/RYSSF0OLPPrTegUCuDEsnBeR9uQ=";
    };
    x86_64-darwin = {
      url = "https://www.rarlab.com/rar/rarosx-${version}.tar.gz";
      sha256 = "sha256-baZ71vYXIGs25f7PJ0ujoGUrsWZRmFLhvDI0KoVktsg=";
    };
  }.${stdenv.system} or (throw "Unsupported system: ${stdenv.system}");
  manSrc = fetchurl {
    url = "https://aur.archlinux.org/cgit/aur.git/plain/rar.1?h=rar&id=8e39a12e88d8a3b168c496c44c18d443c876dd10";
    name = "rar.1";
    sha256 = "sha256-93cSr9oAsi+xHUtMsUvICyHJe66vAImS2tLie7nt8Uw=";
  };
in
stdenv.mkDerivation rec {
  pname = "rar";
  inherit version;

  src = fetchurl srcUrl;

  dontBuild = true;

  buildInputs = [ stdenv.cc.cc.lib ];

  nativeBuildInputs = [ autoPatchelfHook installShellFiles ];

  installPhase = ''
    runHook preInstall

    install -Dm755 {rar,unrar} -t "$out/bin"
    install -Dm755 default.sfx -t "$out/lib"
    install -Dm644 {acknow.txt,license.txt} -t "$out/share/doc/rar"
    install -Dm644 rarfiles.lst -t "$out/etc"

    runHook postInstall
  '';

  postInstall = ''
    installManPage ${manSrc}
  '';

  meta = with lib; {
    description = "Utility for RAR archives";
    homepage = "https://www.rarlab.com/";
    license = licenses.unfree;
    maintainers = with maintainers; [ thiagokokada ];
    platforms = with platforms; linux ++ darwin;
  };
}
