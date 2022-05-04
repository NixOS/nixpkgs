{ lib
, python3
, fetchFromGitHub
}:

python3.pkgs.buildPythonApplication rec {
  pname = "getmail6";
  version = "6.18.6";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "08a5yw6ll1kmd1ardj8rzhsw4wl48zzdc87g5lh4p5snv8w2m4ja";
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
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ abbe dotlambda ];
  };
}
