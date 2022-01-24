{ lib, stdenv, fetchFromGitHub, fetchurl, apacheHttpd }:

let
  apache-24-patch = fetchurl {
    name = "compile-against-apache24.diff";
    url = "https://projects.archlinux.org/svntogit/packages.git/plain/trunk/compile-against-apache24.diff?h=packages/mod_fastcgi&id=81c7cb99d15682df3bdb1edcaeea5259e9e43a42";
    sha256 = "000qvrf5jb979i37rimrdivcgjijcffgrpkx38c0rn62z9jz61g4";
  };
in
stdenv.mkDerivation rec {
  pname = "mod_fastcgi";
  version = "2.4.7.1";

  src = fetchFromGitHub {
    owner = "FastCGI-Archives";
    repo = "mod_fastcgi";
    rev = version;
    hash = "sha256-ovir59kCjKkgbraX23nsmzlMzGdeNTyj3MQd8cgvLsg=";
  };

  patches = [ apache-24-patch ];

  buildInputs = [ apacheHttpd ];

  preBuild = ''
    cp Makefile.AP2 Makefile
    makeFlags="top_dir=${apacheHttpd.dev}/share prefix=$out"
  '';

  meta = {
    homepage = "https://github.com/FastCGI-Archives/mod_fastcgi";
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

    platforms = lib.platforms.linux;
    broken = true; # patch 'compile-against-apache24.diff' no longer works
  };
}
