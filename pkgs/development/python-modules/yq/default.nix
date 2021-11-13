{ lib
, nixosTests
, buildPythonPackage
, fetchPypi
, substituteAll
, argcomplete
, pyyaml
, xmltodict
, jq
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "yq";
  version = "2.12.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2f156d0724b61487ac8752ed4eaa702a5737b804d5afa46fa55866951cd106d2";
  };

  patches = [
    (substituteAll {
      src = ./jq-path.patch;
      jq = "${lib.getBin jq}/bin/jq";
    })
  ];

  postPatch = ''
    substituteInPlace test/test.py \
      --replace "expect_exit_codes={0} if sys.stdin.isatty() else {2}" "expect_exit_codes={0}"
  '';

  propagatedBuildInputs = [
    pyyaml
    xmltodict
    argcomplete
  ];

  checkInputs = [
   pytestCheckHook
  ];

  pytestFlagsArray = [ "test/test.py" ];

  pythonImportsCheck = [ "yq" ];

  doInstallCheck = true;
  installCheckPhase = ''
    echo '{"hello":{"foo":"bar"}}' | $out/bin/yq -y . | grep 'foo: bar'
  '';

  meta = with lib; {
    description = "Command-line YAML processor - jq wrapper for YAML documents";
    homepage = "https://github.com/kislyuk/yq";
    license = licenses.asl20;
    maintainers = with maintainers; [ womfoo SuperSandro2000 ];
  };
}
