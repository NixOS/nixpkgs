{ lib
, python3Packages
, fetchFromGitHub
, pytestCheckHook
, requests
}:

python3Packages.buildPythonPackage rec {
  pname = "timetagger";
  version = "22.1.2";

  src = fetchFromGitHub {
    owner = "almarklein";
    repo = pname;
    rev = "v${version}";
    sha256 = "0xrajx0iij7r70ch17m4y6ydyh368dn6nbjsv74pn1x8frd686rw";
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
