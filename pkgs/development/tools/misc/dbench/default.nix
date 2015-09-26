{ stdenv, fetchgit, autoconf, popt, zlib }:

stdenv.mkDerivation rec {
  name = "dbench-2013-01-01";

  src = fetchgit {
    url = git://git.samba.org/sahlberg/dbench.git;
    rev = "65b19870ed8d25bff14cafa1c30beb33f1fb6597";
    sha256 = "0hzn7xr58y7f01hp02d0ciy2n5awskypfbdc56ff1vkr1b12i2p9";
  };

  buildInputs = [ autoconf popt zlib ];

  preConfigure = ''
    ./autogen.sh
  '';

  postInstall = ''
    cp -R loadfiles/* $out/share
  '';

  meta = with stdenv.lib; {
    description = "Filesystem benchmark tool based on load patterns";
    homepage = https://dbench.samba.org/;
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = [ maintainers.bjornfor ];
  };
}
