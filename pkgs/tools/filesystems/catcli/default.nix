{ lib
, fetchFromGitHub
, buildPythonApplication
, docopt, anytree
}:

buildPythonApplication rec {

  pname = "catcli";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "deadc0de6";
    repo = pname;
    rev = "v${version}";
    sha256 = "0704022gbm987q6x6vcflq4b4p4hvcqm5ikiyndy5n8fj1q8lq95";
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
