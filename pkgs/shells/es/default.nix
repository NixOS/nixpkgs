{ stdenv, fetchgit, readline, yacc, autoconf, automake, libtool }:

let
  version = "git-2015-04-11";
in
stdenv.mkDerivation {

  name = "es-${version}";

  src = fetchgit {
    url = "git://github.com/wryun/es-shell";
    rev = "fdf29d5296ce3a0ef96d2b5952cff07878753975";
    sha256 = "1hj0g8r59ry9l50h4gdal38nf8lvb3cgl6c9bx5aabkw5i778dfk";
  };

  buildInputs = [ readline yacc libtool autoconf automake ];

  preConfigure =
    ''
      aclocal
      autoconf
      libtoolize -qi
    '';

  configureFlags="--with-readline --prefix=$(out) --bindir=$(out)/bin --mandir=$(out)/man";

  preInstall = ''
    mkdir -p $out/bin
    mkdir -p $out/man/man1
  '';

  meta = with stdenv.lib; {
    description = "Es is an extensible shell";
    longDescription =
      ''
        Es is an extensible shell. The language was derived
        from the Plan 9 shell, rc, and was influenced by
        functional programming languages, such as Scheme,
        and the Tcl embeddable programming language.
      '';
    homepage = http://wryun.github.io/es-shell/;
    license = licenses.publicDomain;
    maintainers = [ maintainers.sjmackenzie ];
    platforms = platforms.all;
  };
}
