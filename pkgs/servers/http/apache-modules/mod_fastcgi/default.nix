{ stdenv, fetchurl, apacheHttpd }:

stdenv.mkDerivation {
  name = "mod_fastcgi-2.4.6";

  src = fetchurl {
    url = "http://www.fastcgi.com/dist/mod_fastcgi-2.4.6.tar.gz";
    sha256 = "12g6vcfl9jl8rqf8lzrkdxg2ngca310d3d6an563xqcgrkp8ga55";
  };

  buildInputs = [ apacheHttpd ];

  preBuild = ''
    cp Makefile.AP2 Makefile
    makeFlags="top_dir=${apacheHttpd} prefix=$out"
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
  };
}
