{ lib, stdenv, fetchurl, makeWrapper, binutils-unwrapped }:

stdenv.mkDerivation rec {
  pname = "chkrootkit";
  version = "0.54";

  src = fetchurl {
    url = "ftp://ftp.pangeia.com.br/pub/seg/pac/${pname}-${version}.tar.gz";
    sha256 = "01snj54hhgiqzs72hzabq6abcn46m1yckjx7503vcggm45lr4k0m";
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
    homepage = "http://www.chkrootkit.org/";
    license = licenses.bsd2;
    platforms = with platforms; linux;
  };
}
