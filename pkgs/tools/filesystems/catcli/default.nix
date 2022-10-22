{ lib
, fetchFromGitHub
, buildPythonApplication
, docopt, anytree
}:

buildPythonApplication rec {

  pname = "catcli";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "deadc0de6";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-IHHlxF/7U7C+wO6YicesZPFV6BSBmdkPWaZn7awplNk=";
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
