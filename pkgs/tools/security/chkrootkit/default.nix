{ lib, stdenv, fetchurl, makeWrapper, binutils-unwrapped }:

stdenv.mkDerivation rec {
  pname = "chkrootkit";
  version = "0.55";

  src = fetchurl {
    url = "ftp://ftp.chkrootkit.org/pub/seg/pac/${pname}-${version}.tar.gz";
    sha256 = "sha256-qBwChuxEkxP5U3ASAqAOgbIE/Cz0PieFhaEcEqXgJYs=";
  };

  # TODO: a lazy work-around for linux build failure ...
  makeFlags = [ "STATIC=" ];

  nativeBuildInputs = [ makeWrapper ];

  postPatch = ''
    substituteInPlace chkrootkit \
      --replace " ./" " $out/bin/"
  '';

  installPhase = ''
    mkdir -p $out/sbin
    cp check_wtmpx chkdirs chklastlog chkproc chkrootkit chkutmp chkwtmp ifpromisc strings-static $out/sbin

    wrapProgram $out/sbin/chkrootkit \
      --prefix PATH : "${lib.makeBinPath [ binutils-unwrapped ]}"
  '';

  meta = with lib; {
    description = "Locally checks for signs of a rootkit";
    homepage = "https://www.chkrootkit.org/";
    license = licenses.bsd2;
    platforms = with platforms; linux;
  };
}
