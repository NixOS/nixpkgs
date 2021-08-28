{ lib, stdenv, fetchurl, which, bison, flex, libmaa, zlib, libtool }:

stdenv.mkDerivation rec {
  pname = "dictd";
  version = "1.13.0";

  src = fetchurl {
    url = "mirror://sourceforge/dict/dictd-${version}.tar.gz";
    sha256 = "1r413a78sa3mcrgddgdj1za34dj6mnd4dg66csqv2yz8fypm3fpf";
  };

  buildInputs = [ libmaa zlib ];

  nativeBuildInputs = [ bison flex libtool which ];

  # In earlier versions, parallel building was not supported but it's OK with 1.13
  enableParallelBuilding = true;

  patchPhase = "patch -p0 < ${./buildfix.diff}";

  configureFlags = [
    "--enable-dictorg"
    "--datadir=/run/current-system/sw/share/dictd"
    "--sysconfdir=/etc"
  ];

  postInstall = ''
    install -Dm444 -t $out/share/doc/${pname} NEWS README
  '';

  meta = with lib; {
    description = "Dict protocol server and client";
    homepage = "http://www.dict.org";
    license = licenses.gpl2;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
  };
}
