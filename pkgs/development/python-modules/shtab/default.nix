{ lib
, stdenv
, buildPythonPackage
, pythonOlder
, fetchPypi
, bashInteractive
, pytestCheckHook
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "shtab";
  version = "1.4.2";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    pname = "shtab";
    inherit version;
    sha256 = "sha256-oR8pa/FJ3ywcx4GUHkhRkSmK0bdF3BHQHLImxVWv98s=";
  };

  buildInputs = [ setuptools-scm ];

  checkInputs = [ bashInteractive pytestCheckHook ];
  pythonImportsCheck = [ "shtab" ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "use_scm_version=True" "version='${version}'"

    substituteInPlace setup.cfg \
      --replace "--cov=shtab" "" \
      --replace "--cov-report=term-missing" "" \
      --replace "--cov-report=xml" "" \
      --replace "timeout = 5" ""
  '';

  meta = with lib; {
    homepage = "https://github.com/iterative/shtab";
    description = "Automagic shell tab completion for Python CLI applications";
    maintainers = with maintainers; [ michaeladler ];
    license = licenses.asl20;
  };
}
