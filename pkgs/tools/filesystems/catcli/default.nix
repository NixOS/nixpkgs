{ lib
, fetchFromGitHub
, buildPythonApplication
, docopt, anytree
}:

buildPythonApplication rec {

  pname = "catcli";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "deadc0de6";
    repo = pname;
    rev = "v${version}";
    sha256 = "1k5xjz353ry0vbmq1ql7brb9g4wwsijzix2zh5zpd768xl8nc1z8";
  };

  propagatedBuildInputs = [ docopt anytree ];

  postPatch = "patchShebangs . ";

  meta = with lib; {
    description = "The command line catalog tool for your offline data";
    homepage = "https://github.com/deadc0de6/catcli";
    license = licenses.gpl3;
    maintainers = with maintainers; [ petersjt014 ];
    platforms = platforms.linux;
  };
}
