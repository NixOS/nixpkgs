{ lib, buildPythonApplication, fetchFromGitHub, slurp }:

buildPythonApplication rec {
  pname = "swaytools";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "tmccombs";
    repo = "swaytools";
    rev = version;
    sha256 = "sha256-6Ec7MPqBia0PW+pBTAItLusWMg1wlFfEaxoh20/2uHg=";
  };

  propagatedBuildInputs = [ slurp ];

  meta = with lib; {
    homepage = "https://github.com/tmccombs/swaytools";
    description = "Collection of simple tools for sway (and i3)";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ atila ];
  };
}
