{ lib
, python3Packages
, fetchFromGitHub
, pytestCheckHook
, requests
}:

python3Packages.buildPythonPackage rec {
  pname = "timetagger";
  version = "21.11.2";

  src = fetchFromGitHub {
    owner = "almarklein";
    repo = pname;
    rev = "v${version}";
    sha256 = "0fyxlm5l3xhbp2p9di51pkkb65mrwzyix74nizr2ady43ylpm07p";
  };

  meta = with lib; {
    homepage = "https://timetagger.app";
    license = licenses.gpl3;
    description = "Tag your time, get the insight";
    maintainers = with maintainers; [ matthiasbeyer ];
  };

  checkInputs = [
    pytestCheckHook
    requests
  ];

  preCheck = ''
    # https://github.com/NixOS/nixpkgs/issues/12591
    mkdir -p check-phase
    export HOME=$(pwd)/check-phase
  '';

  propagatedBuildInputs = with python3Packages; [
    asgineer
    itemdb
    jinja2
    markdown
    pscript
    pyjwt
    uvicorn
  ];

}
