{
  lib,
  stdenv,
  fetchurl,
  which,
  bison,
  flex,
  libmaa,
  zlib,
  libtool,
}:

stdenv.mkDerivation rec {
  pname = "dictd";
  version = "1.13.3";

  src = fetchurl {
    url = "mirror://sourceforge/dict/dictd-${version}.tar.gz";
    hash = "sha256-GSEp37OPpyP0ipWGx5xRmPxJBP7BdXF2kXMU3Qc/EXE=";
  };

  patches = [
    ./buildfix.diff
  ];

  buildInputs = [
    libmaa
    zlib
  ];

  nativeBuildInputs = [
    bison
    flex
    libtool
    which
  ];

  # In earlier versions, parallel building was not supported but it's OK with 1.13
  enableParallelBuilding = true;

  configureFlags = [
    "--datadir=/run/current-system/sw/share/dictd"
    "--sysconfdir=/etc"
  ];

  postInstall = ''
    install -Dm444 -t $out/share/doc/${pname} NEWS README
  '';

  meta = {
    description = "Dict protocol server and client";
    homepage = "http://www.dict.org";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ sikmir ];
    platforms = lib.platforms.unix;
  };
}
