{ lib
, fetchFromGitHub
, buildPythonApplication
, docopt, anytree
}:

buildPythonApplication rec {

  pname = "catcli";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "deadc0de6";
    repo = pname;
    rev = "v${version}";
    sha256 = "1hkgf692h3akdxiwhzm3vqibh1ps661qllilf55nyk109cx79gna";
  };

  propagatedBuildInputs = [ docopt anytree ];

  postPatch = "patchShebangs . ";

  meta = with lib; {
    description = "The command line catalog tool for your offline data";
    homepage = "https://github.com/deadc0de6/catcli";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ petersjt014 ];
    platforms = platforms.all;
  };
}
