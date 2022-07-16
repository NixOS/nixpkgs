{ lib, python3Packages, fetchFromGitHub }:

python3Packages.buildPythonApplication rec {
  pname = "mloader";
  version = "1.1.8";

  # PyPI tarball doesn't ship requirements.txt
  src = fetchFromGitHub {
    owner = "hurlenko";
    repo = "mloader";
    rev = version;
    sha256 = "sha256-cZ9jaRrzzc5M7QYGuLxMv1J1mlfp/UEJ4dugTuJIQ/A=";
  };

  propagatedBuildInputs = with python3Packages; [
    click
    protobuf
    requests
  ];

  # No tests in repository
  doCheck = false;

  pythonImportsCheck = [ "mloader" ];

  meta = with lib; {
    description = "Command-line tool to download manga from mangaplus";
    homepage = "https://github.com/hurlenko/mloader";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ marsam ];
  };
}
