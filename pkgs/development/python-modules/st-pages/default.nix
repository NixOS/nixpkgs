{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  streamlit,
  poetry-core,
}:
buildPythonPackage rec {
  pname = "st-pages";
  version = "1.0.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "blackary";
    repo = "st_pages";
    tag = "v${version}";
    hash = "sha256-sJXgpRiducJVYuyvVvTZthHnIJyIRn+f9Uw/wAMfnm0=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    streamlit
  ];

  meta = {
    description = "An experimental version of Streamlit Multi-Page Apps";
    homepage = "https://github.com/blackary/st_pages";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      keyzox
    ];
  };
}
