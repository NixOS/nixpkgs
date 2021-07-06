{ lib
, stdenv
, fetchurl
, pkg-config
, readline
, guileSupport ? false
, guile
}:

stdenv.mkDerivation rec {
  pname = "remake";
  remakeVersion = "4.3";
  dbgVersion = "1.5";
  version = "${remakeVersion}+dbg-${dbgVersion}";

  src = fetchurl {
    url = "mirror://sourceforge/project/bashdb/remake/${version}/remake-${remakeVersion}+dbg-${dbgVersion}.tar.gz";
    sha256 = "0xlx2485y0israv2pfghmv74lxcv9i5y65agy69mif76yc4vfvif";
  };

  patches = [
    ./glibc-2.27-glob.patch
  ];

  nativeBuildInputs = [
    pkg-config
  ];
  buildInputs = [ readline ]
    ++ lib.optionals guileSupport [ guile ];

  # make check fails, see https://github.com/rocky/remake/issues/117

  meta = {
    homepage = "http://bashdb.sourceforge.net/remake/";
    license = lib.licenses.gpl3Plus;
    description = "GNU Make with comprehensible tracing and a debugger";
    platforms = with lib.platforms; linux ++ darwin;
    maintainers = with lib.maintainers; [ bjornfor shamilton ];
  };
}
