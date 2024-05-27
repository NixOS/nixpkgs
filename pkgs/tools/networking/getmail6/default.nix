{ lib
, python3
, fetchFromGitHub
}:

python3.pkgs.buildPythonApplication rec {
  pname = "getmail6";
  version = "6.18.14";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "getmail6";
    repo = "getmail6";
    rev = "refs/tags/v${version}";
    hash = "sha256-NcUGIddbIjwMyE/6fR8lqs90/chzqROQDftF/cNkxOs=";
  };

  nativeBuildInputs = with python3.pkgs; [
    setuptools
  ];

  # needs a Docker setup
  doCheck = false;

  pythonImportsCheck = [ "getmailcore" ];

  postPatch = ''
    # getmail spends a lot of effort to build an absolute path for
    # documentation installation; too bad it is counterproductive now
    sed -e '/datadir or prefix,/d' -i setup.py
    sed -e 's,/usr/bin/getmail,$(dirname $0)/getmail,' -i getmails
  '';

  meta = with lib; {
    description = "A program for retrieving mail";
    homepage = "https://getmail6.org";
    changelog = "https://github.com/getmail6/getmail6/blob/${src.rev}/docs/CHANGELOG";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ abbe dotlambda ];
  };
}
