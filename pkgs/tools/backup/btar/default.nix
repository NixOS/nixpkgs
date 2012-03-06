{ stdenv, fetchurl, librsync }:

stdenv.mkDerivation rec {
  name = "btar-0.9.2";
  src = fetchurl {
    url = "http://vicerveza.homeunix.net/~viric/soft/btar/${name}.tar.gz";
    sha256 = "113l5qn3qizxnv2r0w8awnm9agjsmf39fl5w9gcvrxqy021f2jd9";
  };

  buildInputs = [ librsync ];

  installPhase = "make install PREFIX=$out";

  meta = {
    description = "Tar-compatible block-based archiver";
    license = "GPLv3+";
    homepage = http://viric.name/cgi-bin/btar;
    platforms = with stdenv.lib.platforms; all;
    maintainers = with stdenv.lib.maintainers; [viric];
  };
}
