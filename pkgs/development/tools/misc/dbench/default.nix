{stdenv, fetchgit, autoconf, popt, zlib}: 

stdenv.mkDerivation rec {
  name = "dbench-20101121";

  buildInputs = [autoconf popt zlib];

  preConfigure = ''
    ./autogen.sh
  '';

  src = fetchgit {
    url = git://git.samba.org/sahlberg/dbench.git;
    rev = "8b5143bcc0f4409553392fdf12fd21c95a075fae";
    sha256 = "607a62b7ff2e9b1393980777e0ba239215dd8145bc1a34649bcbe2b1e567006d";
  };

  postInstall = ''
    cp -R loadfiles/* $out/share
  '';

}
