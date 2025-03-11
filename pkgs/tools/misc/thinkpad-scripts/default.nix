{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  python3Packages,
}:

buildPythonPackage rec {
  pname = "thinkpad-scripts";
  version = "4.12.0";

  src = fetchFromGitHub {
    owner = "martin-ueding";
    repo = "thinkpad-scripts";
    rev = "v${version}";
    sha256 = "08adx8r5pwwazbnfahay42l5f203mmvcn2ipz5hg8myqc9jxm2ky";
  };

  propagatedBuildInputs = with python3Packages; [ setuptools ];

  meta = {
    description = "Screen rotation, docking and other scripts for ThinkPad® X220 and X230 Tablet";
    homepage = "https://github.com/martin-ueding/thinkpad-scripts";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ dawidsowa ];
  };
}
