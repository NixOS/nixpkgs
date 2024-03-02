{ lib, stdenv, fetchurl, which, bison, flex, libmaa, zlib, libtool }:

stdenv.mkDerivation rec {
  pname = "dictd";
  version = "1.13.1";

  src = fetchurl {
    url = "mirror://sourceforge/dict/dictd-${version}.tar.gz";
    sha256 = "sha256-5PGmfRaJTYSUVp19yUQsFcw4wBHyuWMcfxzGInZlKhs=";
  };

  buildInputs = [ libmaa zlib ];

  nativeBuildInputs = [ bison flex libtool which ];

  # In earlier versions, parallel building was not supported but it's OK with 1.13
  enableParallelBuilding = true;

  patchPhase = "patch -p0 < ${./buildfix.diff}";

  configureFlags = [
    "--datadir=/run/current-system/sw/share/dictd"
    "--sysconfdir=/etc"
  ];

  postInstall = ''
    install -Dm444 -t $out/share/doc/${pname} NEWS README
  '';

  meta = with lib; {
    description = "Dict protocol server and client";
    homepage = "http://www.dict.org";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ sikmir ];
    platforms = platforms.unix;
  };
}
