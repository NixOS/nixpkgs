{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, click
, textual
}:

buildPythonPackage rec {
  pname = "trogon";
  version = "0.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Textualize";
    repo = "trogon";
    rev = "v${version}";
    hash = "sha256-5FMivnQ/+39MmYUmkAZwtH09FpTYDEDtsdmTrUCLHqY=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    click
    textual
  ];

  pythonImportsCheck = [ "trogon" ];

  meta = with lib; {
    description = "Easily turn your Click CLI into a powerful terminal application";
    homepage = "https://github.com/Textualize/trogon";
    license = licenses.mit;
    maintainers = with maintainers; [ edmundmiller ];
  };
}
