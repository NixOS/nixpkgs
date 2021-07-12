{ lib
, python3
, fetchFromGitHub
}:

python3.pkgs.buildPythonApplication rec {
  pname = "getmail6";
  version = "6.18.3";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-8tBSi9QzWcVL09j6aa2yWFhLlqaI6DREX2PpKvHC3qU=";
  };

  # needs a Docker setup
  doCheck = false;

  pythonImportsCheck = [ "getmailcore" ];

  postPatch = ''
    # getmail spends a lot of effort to build an absolute path for
    # documentation installation; too bad it is counterproductive now
    sed -e '/datadir or prefix,/d' -i setup.py
  '';

  meta = with lib; {
    description = "A program for retrieving mail";
    homepage = "https://getmail6.org";
    updateWalker = true;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ abbe dotlambda ];
  };
}
