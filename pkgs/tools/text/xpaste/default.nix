{ lib
, fetchFromGitHub
, python3Packages
}:

python3Packages.buildPythonApplication rec {
  pname = "xpaste";
  version = "1.5";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "ossobv";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-Z9YxhVP+FUvWET91ob4SPSW+XX7/wzlgPr53vO517L4=";
  };

  propagatedBuildInputs = with python3Packages; [
    xlib
  ];

  # no tests
  doCheck = false;

  meta = with lib; {
    description = "Paste text into X windows that don't work with selections";
    homepage = "https://github.com/ossobv/xpaste";
    license = licenses.gpl3;
    maintainers = with maintainers; [ gador ];
  };
}
