{ lib, python3Packages, slurp }:

python3Packages.buildPythonApplication rec {
  pname = "swaytools";
  version = "0.1.0";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "1eb89259cbe027a0fa6bfc06ecf94e89b15e6f7b4965104e5b661c916ce7408c";
  };

  propagatedBuildInputs = [ slurp ];

  passthru.updateScript = ./update.py;

  meta = with lib; {
    homepage = "https://github.com/tmccombs/swaytools";
    description = "Collection of simple tools for sway (and i3)";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ atila ];
  };
}
