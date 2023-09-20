{ lib
, callPackage
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "attrs";
  version = "21.4.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-YmuoI0IR25joad92IwoTfExAoS1yRFxF1fW3FvB24v0=";
  };

  outputs = [
    "out"
    "testout"
  ];

  postInstall = ''
    # Install tests as the tests output.
    mkdir $testout
    cp -R tests $testout/tests
  '';

  pythonImportsCheck = [
    "attr"
  ];

  # pytest depends on attrs, so we can't do this out-of-the-box.
  # Instead, we do this as a passthru.tests test.
  doCheck = false;

  passthru.tests = {
    pytest = callPackage ./tests.nix { };
  };

  meta = with lib; {
    description = "Python attributes without boilerplate";
    homepage = "https://github.com/hynek/attrs";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
