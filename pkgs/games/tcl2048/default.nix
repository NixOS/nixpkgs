{ stdenv, fetchurl, tcl, tcllib }:

stdenv.mkDerivation {
  name = "tcl2048-0.4.0";

  src = fetchurl {
    url = https://raw.githubusercontent.com/dbohdan/2048.tcl/v0.4.0/2048.tcl;
    sha256 = "53f5503efd7f029b2614b0f9b1e3aac6c0342735a3c9b811d74a5135fee3e89e";
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
    homepage = https://github.com/dbohdan/2048.tcl;
    description = "The game of 2048 implemented in Tcl";
    license = stdenv.lib.licenses.mit;
    platforms = stdenv.lib.platforms.all;
    maintainers = with stdenv.lib.maintainers; [ dbohdan ];
  };
}
