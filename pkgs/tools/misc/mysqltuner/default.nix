{ lib, stdenv, fetchFromGitHub, perl }:

stdenv.mkDerivation rec {
  pname = "mysqltuner";
  version = "1.7.21";

  src = fetchFromGitHub {
    owner  = "major";
    repo   = "MySQLTuner-perl";
    rev    = version;
    sha256 = "sha256-Yv1XjD8sZcmGr2SVD6TEElUH7vspJ61WwQwfXLOrao0=";
  };

  postPatch = ''
    substituteInPlace mysqltuner.pl \
      --replace '$basic_password_files = "/usr/share/mysqltuner/basic_passwords.txt"' "\$basic_password_files = \"$out/share/basic_passwords.txt\"" \
      --replace '$opt{cvefile} = "/usr/share/mysqltuner/vulnerabilities.csv"' "\$opt{cvefile} = \"$out/share/vulnerabilities.csv\""
  '';

  buildInputs = [ perl ];

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/bin"
    install -Dm 0755 mysqltuner.pl "$out/bin/mysqltuner"
    install -Dm 0644 basic_passwords.txt "$out/share/basic_passwords.txt"
    install -Dm 0644 vulnerabilities.csv "$out/share/vulnerabilities.csv"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Make recommendations for increased performance and stability of MariaDB/MySQL";
    homepage = "http://mysqltuner.com";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ peterhoeg shamilton ];
  };
}
