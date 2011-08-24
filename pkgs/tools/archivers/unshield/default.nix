{stdenv, fetchsvn, zlib, autoconf, automake, libtool}:

stdenv.mkDerivation {
  name = "unshield-0.7pre3955";
  src = fetchsvn {
    url = https://synce.svn.sourceforge.net/svnroot/synce/trunk/unshield;
    rev = 3955;
    sha256 = "0rpk7sb7b0v19qn4jn0iih505l4zkpns3mrbmm88p61xiz06zg7a";
  };
  configureFlags = "--with-zlib=${zlib}";
  buildInputs = [autoconf automake libtool];
  preConfigure = ''
    ./bootstrap
  '';
}
