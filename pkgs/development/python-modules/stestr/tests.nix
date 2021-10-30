{ stdenv
, buildPythonPackage
, ddt
, sqlalchemy
, stestr
, subunit2sql
}:

buildPythonPackage rec {
  pname = "stestr-tests";
  inherit (stestr) version;

  src = stestr.src;

  postPatch = ''
    # only a small portion of the listed packages are actually needed for running the tests
    # so instead of removing them one by one remove everything
    rm test-requirements.txt
  '';

  dontBuild = true;
  dontInstall = true;

  checkInputs = [
    stestr
  ];

  checkPhase = ''
    export PATH=$out/bin:$PATH
    export HOME=$TMPDIR
  '';
}
