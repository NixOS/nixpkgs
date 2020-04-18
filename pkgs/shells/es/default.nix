{ stdenv, fetchurl, readline, yacc }:

let
  version = "0.9.1";
in
stdenv.mkDerivation {

  pname = "es";
  inherit version;

  src = fetchurl {
    url = "https://github.com/wryun/es-shell/releases/download/v${version}/es-${version}.tar.gz";
    sha256 = "1fplzxc6lncz2lv2fyr2ig23rgg5j96rm2bbl1rs28mik771zd5h";
  };

  # The distribution tarball does not have a single top-level directory.
  preUnpack = ''
    mkdir $name
    cd $name
    sourceRoot=.
  '';

  buildInputs = [ readline yacc ];

  configureFlags = [ "--with-readline" ];

  meta = with stdenv.lib; {
    description = "Es is an extensible shell";
    longDescription =
      ''
        Es is an extensible shell. The language was derived
        from the Plan 9 shell, rc, and was influenced by
        functional programming languages, such as Scheme,
        and the Tcl embeddable programming language.
      '';
    homepage = "http://wryun.github.io/es-shell/";
    license = licenses.publicDomain;
    maintainers = with maintainers; [ sjmackenzie ttuegel ];
    platforms = platforms.all;
  };

  passthru = {
    shellPath = "/bin/es";
  };
}
