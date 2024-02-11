{ lib, python3Packages, fetchFromGitHub }:

python3Packages.buildPythonApplication rec {
  pname = "parsero";
  version = "0.81";

  src = fetchFromGitHub {
    owner = "behindthefirewalls";
    repo = pname;
    rev = "e5b585a19b79426975a825cafa4cc8a353cd267e";
    sha256 = "rqupeJxslL3AfQ+CzBWRb4ZS32VoYd8hlA+eACMKGPY=";
  };

  propagatedBuildInputs = with python3Packages; [
    beautifulsoup4
    urllib3
  ];

  # Project has no tests
  doCheck = false;

  meta = with lib; {
    description = "Robots.txt audit tool";
    homepage = "https://github.com/behindthefirewalls/Parsero";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ emilytrau fab ];
    mainProgram = "parsero";
  };
}
