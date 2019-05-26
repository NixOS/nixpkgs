{ stdenv, fetchurl, readline }:

stdenv.mkDerivation rec {
  name = "remake-${version}";
  remakeVersion = "4.1";
  dbgVersion = "1.1";
  version = "${remakeVersion}+dbg-${dbgVersion}";

  src = fetchurl {
    url = "mirror://sourceforge/project/bashdb/remake/${version}/remake-${remakeVersion}+dbg${dbgVersion}.tar.bz2";
    sha256 = "1zi16pl7sqn1aa8b7zqm9qnd9vjqyfywqm8s6iap4clf86l7kss2";
  };

  patches = [
    ./glibc-2.27-glob.patch
  ];

  buildInputs = [ readline ];

  meta = {
    homepage = http://bashdb.sourceforge.net/remake/;
    license = stdenv.lib.licenses.gpl3;
    description = "GNU Make with comprehensible tracing and a debugger";
    platforms = with stdenv.lib.platforms; linux ++ darwin;
    maintainers = with stdenv.lib.maintainers; [ bjornfor ];
  };
}
