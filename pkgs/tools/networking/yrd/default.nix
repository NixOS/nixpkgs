{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "yrd";
  version = "0.5.3";

  src = fetchFromGitHub {
    owner = "kpcyrd";
    repo = pname;
    rev = "v${version}";
    sha256 = "1yx1hr8z4cvlb3yi24dwafs0nxq41k4q477jc9q24w61a0g662ps";
  };

  propagatedBuildInputs = with python3.pkgs; [
    argh
    requests
  ];

  nativeCheckInputs = with python3.pkgs; [
    nose
  ];

  checkPhase = ''
    nosetests -v yrd
  '';

  meta = with lib; {
    description = "Cjdns swiss army knife";
    maintainers = with maintainers; [ akru ];
    platforms = platforms.linux;
    license = licenses.gpl3Only;
    homepage = "https://github.com/kpcyrd/yrd";
  };
}
