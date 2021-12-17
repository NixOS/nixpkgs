{ lib
, fetchFromGitHub
, buildPythonApplication
, docopt, anytree
}:

buildPythonApplication rec {

  pname = "catcli";
  version = "0.7.4";

  src = fetchFromGitHub {
    owner = "deadc0de6";
    repo = pname;
    rev = "v${version}";
    sha256 = "1mzhfcf67dc5m0i9b216m58qg36g63if6273ch5bsckd0yrwdk8x";
  };

  propagatedBuildInputs = [ docopt anytree ];

  postPatch = "patchShebangs . ";

  meta = with lib; {
    description = "The command line catalog tool for your offline data";
    homepage = "https://github.com/deadc0de6/catcli";
    license = licenses.gpl3;
    maintainers = with maintainers; [ petersjt014 ];
    platforms = platforms.all;
  };
}
