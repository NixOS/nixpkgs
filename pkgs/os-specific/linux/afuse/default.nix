{ stdenv, fetchgit, pkgconfig, autoreconfHook, fuse }:

stdenv.mkDerivation {
  name = "afuse-0.4.1";

  src = fetchgit {
    url = git://github.com/pcarrier/afuse.git;
    rev = "a0892f5506ddcca2031825aff24f1518c8c2f1c8";
    sha256 = "12071ff5171d4d5ce4d8835385f50e8079b25e885816b8ad6f22eb46c6497b28";
  };

  buildInputs = [ autoreconfHook pkgconfig fuse ];

  meta = {
    description = "Automounter in userspace";
    homepage = https://github.com/pcarrier/afuse;
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.marcweber ];
    platforms = stdenv.lib.platforms.linux;
  };
}
