{stdenv, fetchurl, groff, less}:
 
stdenv.mkDerivation {
  name = "man-1.6f";
  
  src = fetchurl {
    url = http://primates.ximian.com/~flucifredi/man/man-1.6f.tar.gz;
    sha256 = "0v2z6ywhy8kd2fa3ywkqayhjdivbaqn6qvhx93a1ldw135z8q84z";
  };
  
  buildInputs = [groff less];

  preBuild = ''
    makeFlagsArray=(bindir=$out/bin sbindir=$out/sbin libdir=$out/lib mandir=$out/share/man)
  '';

  patches = [
    # Search in "share/man" relative to each path in $PATH (in addition to "man").
    ./share.patch
  ];

  meta = {
    homepage = http://primates.ximian.com/~flucifredi/man/;
    description = "Tool to read online Unix documentation";
  };
}
