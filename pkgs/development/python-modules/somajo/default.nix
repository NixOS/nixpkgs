{ lib
, stdenv
, fetchFromGitHub
, buildPythonPackage
, pythonOlder
, regex
}:

buildPythonPackage rec {
  pname = "somajo";
  version = "2.2.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "tsproisl";
    repo = "SoMaJo";
    rev = "v${version}";
    sha256 = "sha256-M0WtONhsqmmK0PBB+Df4YrFpT+vfVidDkt80eBHOo04=";
  };

  propagatedBuildInputs = [
    regex
  ];

  # loops forever
  doCheck = !stdenv.isDarwin;

  pythonImportsCheck = [
    "somajo"
  ];

  meta = with lib; {
    description = "Tokenizer and sentence splitter for German and English web texts";
    homepage = "https://github.com/tsproisl/SoMaJo";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ];
  };
}
