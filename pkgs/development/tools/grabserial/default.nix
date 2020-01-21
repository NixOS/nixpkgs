{ lib, fetchFromGitHub, pythonPackages }:

pythonPackages.buildPythonApplication rec {
  pname = "grabserial";
  version = "1.9.9";

  src = fetchFromGitHub {
    owner = "tbird20d";
    repo = "grabserial";
    rev = "v${version}";
    sha256 = "0cwrajkh605gfhshrlpbc32gmx86a8kv3pq7cv713k60sgqrgpqx";
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
