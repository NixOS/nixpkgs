{ fetchFromGitHub, lib, python3 }:

python3.pkgs.buildPythonApplication rec {
  pname = "keymapviz";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "yskoht";
    repo = pname;
    rev = version;
    sha256 = "sha256-lNpUH4BvlnHx0SDq5YSsHdcTeEnf6MH2WRUEsCWWHA0=";
  };

  propagatedBuildInputs = with python3.pkgs; [ regex ];

  meta = with lib; {
    description = "A qmk keymap.c visualizer";
    homepage = "https://github.com/yskoht/keymapviz";
    license = licenses.mit;
    maintainers = with maintainers; [ legendofmiracles ];
  };
}
