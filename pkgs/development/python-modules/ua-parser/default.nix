{ lib
, buildPythonPackage
, fetchFromGitHub
, pyyaml
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "ua-parser";
  version = "0.15.0";

  format = "setuptools";

  src = fetchFromGitHub {
    owner = "ua-parser";
    repo = "uap-python";
    rev = version;
    fetchSubmodules = true;
    hash = "sha256-TtOj1ZL8+4T95AgF9ErvI+0W35WQ23snFhCyCbuRjxM=";
  };

  patches = [
    ./dont-fetch-submodule.patch
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "pyyaml ~= 5.4.0" pyyaml
  '';

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
