{ stdenv, fetchurl, apacheHttpd }:

stdenv.mkDerivation rec {
  name = "mod_fastcgi-2.4.6";

  src = fetchurl {
    url = "http://www.fastcgi.com/dist/${name}.tar.gz";
    sha256 = "12g6vcfl9jl8rqf8lzrkdxg2ngca310d3d6an563xqcgrkp8ga55";
  };

  patches =
    [ (fetchurl {
        name = "compile-against-apache24.diff";
        url = "https://projects.archlinux.org/svntogit/packages.git/plain/trunk/compile-against-apache24.diff?h=packages/mod_fastcgi&id=81c7cb99d15682df3bdb1edcaeea5259e9e43a42";
        sha256 = "000qvrf5jb979i37rimrdivcgjijcffgrpkx38c0rn62z9jz61g4";
      })
    ];

  buildInputs = [ apacheHttpd ];

  preBuild = ''
    cp Makefile.AP2 Makefile
    makeFlags="top_dir=${apacheHttpd}/share prefix=$out"
  '';

  meta = {
    homepage = "http://www.fastcgi.com/";
    description = "Provide support for the FastCGI protocol";

    longDescription = ''
      mod_fastcgi is a module for the Apache web server that enables
      FastCGI - a standards based protocol for communicating with
      applications that generate dynamic content for web pages. FastCGI
      provides a superset of CGI functionality, but a subset of the
      functionality of programming for a particular web server API.
      Nonetheless, the feature set is rich enough for programming
      virtually any type of web application, but the result is generally
      more scalable.
    '';

    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}
