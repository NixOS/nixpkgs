{ lib, stdenv, fetchurl, unzip, makeWrapper, jre_headless }:

stdenv.mkDerivation rec {
  pname = "maestro";
  version = "1.19.5";

  src = fetchurl {
    url = "https://github.com/mobile-dev-inc/maestro/releases/download/cli-${version}/maestro.zip";
    sha256 = "1chrfwpxbnbn6k6ciwbflz1b8d7sd3r945m5g2d9gz1r1nn6d4v1";
  };

  dontUnpack = true;
  nativeBuildInputs = [ unzip makeWrapper ];

  installPhase = ''
    mkdir $out
    unzip $src -d $out
    mv $out/maestro/* $out
    rm -rf $out/maestro
  '';

  postFixup = ''
    wrapProgram $out/bin/maestro --prefix PATH : "${lib.makeBinPath [ jre_headless ]}"
  '';

  meta = with lib; {
    description = "Mobile UI Automation tool";
    homepage = "https://maestro.mobile.dev/";
    license = licenses.asl20;
    platforms = lib.platforms.all;
    changelog = "https://github.com/mobile-dev-inc/maestro/blob/main/CHANGELOG.md";
    maintainers = with maintainers; [ SubhrajyotiSen ];
  };
}
