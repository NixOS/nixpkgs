{ lib, fetchFromGitHub, pythonPackages }:

let
  pname = "yrd";
  version = "0.5.3";
  sha256 = "1yx1hr8z4cvlb3yi24dwafs0nxq41k4q477jc9q24w61a0g662ps";

in pythonPackages.buildPythonApplication {
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "kpcyrd";
    repo = pname;
    rev = "v${version}";
    inherit sha256;
  };

  propagatedBuildInputs = with pythonPackages; [ argh ];

  meta = with lib; {
    description = "Cjdns swiss army knife";
    maintainers = with maintainers; [ akru ];
    platforms = platforms.linux;
    license = licenses.gpl3;
    homepage = "https://github.com/kpcyrd/yrd";
  };
}
