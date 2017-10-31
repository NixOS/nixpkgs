{ stdenv, fetchurl, lib, rpmextract }:

assert stdenv.isLinux;

with lib;

stdenv.mkDerivation rec {
  name = "aucdtext-${version}";
  version = "0.8-2";

  src = fetchurl {
    url = "http://www.true-audio.com/ftp/aucdtect-${version}.i586.rpm";
    sha256 = "1lp5f0rq5b5n5il0c64m00gcfskarvgqslpryms9443d200y6mmd";
  };

  unpackCmd = "${rpmextract}/bin/rpmextract $src";

  installPhase = ''
    mkdir -p $out/bin
    install -m755 local/bin/auCDtect $out/bin/aucdtect
  '';

  dontStrip = true;

  meta = with stdenv.lib; {
    description = "Verify authenticity of lossless audio files";
    homepage = http://tausoft.org;
    license = licenses.unfreeRedistributable;
    maintainers = with maintainers; [ peterhoeg ];
    platforms = platforms.linux;
  };
}
