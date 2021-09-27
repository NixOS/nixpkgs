{ lib, stdenv, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "soco-cli";
  version = "0.4.21";

  src = fetchFromGitHub rec {
    owner = "avantrec";
    repo = "soco-cli";
    rev = "v${version}";
    sha256 = "1kz2zx59gjfs01jiyzmps8j6yca06yqn6wkidvdk4s3izdm0rarw";
  };

  propagatedBuildInputs = with python3Packages; [
    soco
    tabulate
    rangehttpserver
    fastapi
    uvicorn
  ];

  meta = with lib; {
    homepage = "https://github.com/avantrec/soco-cli";
    description = "Command-line interface to control Sonos sound systems";
    license = licenses.asl20;
    maintainers = with maintainers; [ ajgrf ];
  };
}
