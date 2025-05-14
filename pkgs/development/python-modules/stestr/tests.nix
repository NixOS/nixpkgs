{ buildPythonPackage, stestr }:

buildPythonPackage {
  pname = "stestr-tests";
  inherit (stestr) version src;
  format = "other";

  dontBuild = true;
  dontInstall = true;
  preConfigure = ''
    pythonOutputDistPhase() { touch $dist; }
  '';

  nativeCheckInputs = [ stestr ];

  checkPhase = ''
    export PATH=$out/bin:$PATH
    export HOME=$TMPDIR
  '';
}
