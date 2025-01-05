{
  lib,
  setuptools,
  buildPythonApplication,
  fetchFromGitHub,
  slurp,
}:

buildPythonApplication rec {
  pname = "swaytools";
  version = "0.1.2";

  format = "pyproject";

  src = fetchFromGitHub {
    owner = "tmccombs";
    repo = "swaytools";
    rev = version;
    sha256 = "sha256-UoWK53B1DNmKwNLFwJW1ZEm9dwMOvQeO03+RoMl6M0Q=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ slurp ];

  meta = with lib; {
    homepage = "https://github.com/tmccombs/swaytools";
    description = "Collection of simple tools for sway (and i3)";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ atila ];
    platforms = platforms.linux;
  };
}
