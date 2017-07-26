{ stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec {
  name = "snapraid-${version}";
  version = "11.1";

  src = fetchFromGitHub {
    owner = "amadvance";
    repo = "snapraid";
    rev = "v${version}";
    sha256 = "13v0gz22ng09gs87f7900z2sk2hg5543njl32rfn4cxxp0jncs3r";
  };

  doCheck = true;

  buildInputs = [ autoreconfHook ];

  meta = {
    homepage = http://www.snapraid.it/;
    description = "A backup program for disk arrays";
    license = stdenv.lib.licenses.gpl3;
    maintainers = [ stdenv.lib.maintainers.makefu ];
    platforms = stdenv.lib.platforms.unix;
  };
}
