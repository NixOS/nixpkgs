{ lib, fetchFromGitHub, pythonPackages }:

pythonPackages.buildPythonApplication rec {
  pname = "grabserial";
  version = "1.9.8";

  src = fetchFromGitHub {
    owner = "tbird20d";
    repo = "grabserial";
    rev = "v${version}";
    sha256 = "1xmy3js4hzsxlkxc172hkjzxsc34mmg3vfz61h24c7svmfzyhbd5";
  };

  propagatedBuildInputs = [ pythonPackages.pyserial ];

  meta = with lib; {
    description = "Python based serial dump and timing program";
    homepage = "https://github.com/tbird20d/grabserial";
    license = licenses.gpl2;
    maintainers = with maintainers; [ vmandela ];
    platforms = platforms.linux;
  };
}
