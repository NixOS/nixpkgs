{ stdenv, fetchurl, tcl, tcllib }:

stdenv.mkDerivation {
  name = "tcl2048-0.3.1";

  src = fetchurl {
    url = https://raw.githubusercontent.com/dbohdan/2048-tcl/v0.3.1/2048.tcl;
    sha256 = "44e325328784c4e91cecc0a9cc00e32d733da713adf2fad1c081542f38af3361";
  };

  phases = "installPhase";

  installPhase = ''
    mkdir -pv $out/bin
    cp $src $out/2048.tcl
    cat > $out/bin/2048 << EOF
    #!${stdenv.shell}

    # wrapper for tcl2048
    export TCLLIBPATH="${tcllib}/lib/tcllib${tcllib.version}"
    ${tcl}/bin/tclsh $out/2048.tcl
    EOF

    chmod +x $out/bin/2048
  '';

  meta = {
    homepage = https://github.com/dbohdan/2048-tcl;
    description = "The game of 2048 implemented in Tcl";
    license = stdenv.lib.licenses.mit;
    platforms = stdenv.lib.platforms.all;
    maintainers = with stdenv.lib.maintainers; [ dbohdan ];
  };
}
