{ stdenv, fetchFromGitHub, connman, dmenu }:

stdenv.mkDerivation rec {
  name = "connman_dmenu-${version}";
  version = "git-29-9-2015";

  src = fetchFromGitHub {
    owner = "march-linux";
    repo = "connman_dmenu";
    rev = "cc89fec40b574b0d234afeb70ea3c94626ca3f5c";
    sha256 = "061fi83pai4n19l9d7wq6wwj2d7cixwkhkh742c5ibmw1wb274yk";
  };

  buildInputs = [ connman dmenu ];

  dontBuild = true;

  # remove root requirement, see: https://github.com/march-linux/connman_dmenu/issues/3
  postPatch = ''
    sed -i '89,92d' connman_dmenu
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp connman_dmenu $out/bin/
  '';

  meta = {
    description  = "A dmenu wrapper for connmann";
    homepage     = https://github.com/march-linux/connman_dmenu;
    license      = stdenv.lib.licenses.free;
    maintainers  = [ stdenv.lib.maintainers.magnetophon ];
    platforms    = stdenv.lib.platforms.all;
  };
}
