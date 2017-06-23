{ stdenv
, scyther
, python2
, graphviz
}:

let
  version = scyther.version;
  pythonEnv = python2.withPackages(ps: with ps; [ wxPython graphviz ]);
in stdenv.mkDerivation rec {
  name = "scyther-gui-${version}";

  inherit (scyther) src;

  buildInputs = [ pythonEnv ];

  postPatch = ''
    substituteInPlace gui/Scyther/FindDot.py --replace "DOTLOCATION = scanLocations()" "DOTLOCATION = '${graphviz}/bin'"
  '';

  buildPhase = "true";

  installPhase = ''
    # Install GUI files.
    mkdir -p $out/share
    cp -r gui $out/share/scyther
    ln -s ${scyther}/bin/scyther-linux $out/share/scyther/scyther-linux

    # Install executable
    mkdir -p $out/bin
    ln -s $out/share/scyther/scyther-gui.py $out/bin/scyther-gui

  '';

  passthru = {
    inherit version;
  };

}
