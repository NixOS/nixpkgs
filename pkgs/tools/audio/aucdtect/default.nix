{ stdenv, fetchurl, lib, rpmextract }:

with lib;

stdenv.mkDerivation rec {
  pname = "aucdtect";
  version = "0.8-2";

  src = fetchurl {
    url = "http://www.true-audio.com/ftp/${pname}-${version}.i586.rpm";
    sha256 = "1lp5f0rq5b5n5il0c64m00gcfskarvgqslpryms9443d200y6mmd";
  };

  unpackCmd = "${rpmextract}/bin/rpmextract $src";

  installPhase = ''
    runHook preInstall

    install -Dm755 local/bin/auCDtect $out/bin/aucdtect

    runHook postInstall
  '';

  dontStrip = true;

  meta = with stdenv.lib; {
    description = "Verify authenticity of lossless audio files";
    homepage = "http://tausoft.org";
    license = licenses.unfreeRedistributable;
    maintainers = with maintainers; [ peterhoeg ];
    platforms = platforms.linux;
  };
}
