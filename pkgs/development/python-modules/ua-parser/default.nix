{ lib
, buildPythonPackage
, fetchFromGitHub
, pyyaml
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "ua-parser";
  version = "0.10.0";

  format = "setuptools";

  src = fetchFromGitHub {
    owner = "ua-parser";
    repo = "uap-python";
    rev = version;
    fetchSubmodules = true;
    hash = "sha256-kaTAfUtHj2vH7i7eIU61efuB4/XVHoc/z6o3ny+sgrQ=";
  };

  patches = [
    ./dont-fetch-submodule.patch
  ];

  nativeBuildInputs = [
    pyyaml
  ];

  preBuild = ''
    mkdir -p build/lib/ua_parser
  '';

  checkInputs = [
    pytestCheckHook
  ];

  preCheck = ''
    # import from $out
    rm ua_parser/__init__.py
  '';

  pythonImportsCheck = [ "ua_parser" ];

  meta = with lib; {
    description = "A python implementation of the UA Parser";
    homepage = "https://github.com/ua-parser/uap-python";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ dotlambda ];
  };
}
