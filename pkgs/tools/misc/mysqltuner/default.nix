{ lib, stdenv, fetchFromGitHub, perl }:

stdenv.mkDerivation rec {
  pname = "mysqltuner";
  version = "1.7.21";

  src = fetchFromGitHub {
    owner = "major";
    repo = "MySQLTuner-perl";
    rev = version;
    sha256 = "sha256-Yv1XjD8sZcmGr2SVD6TEElUH7vspJ61WwQwfXLOrao0=";
  };

  postPatch = ''
    substituteInPlace mysqltuner.pl \
      --replace '/usr/share' "$out/share"
  '';

  buildInputs = [ perl ];

  installPhase = ''
    runHook preInstall

    install -Dm0555 mysqltuner.pl $out/bin/mysqltuner
    install -Dm0444 -t $out/share/mysqltuner basic_passwords.txt vulnerabilities.csv

    runHook postInstall
  '';

  meta = with lib; {
    description = "Make recommendations for increased performance and stability of MariaDB/MySQL";
    homepage = "http://mysqltuner.com";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ peterhoeg shamilton ];
  };
}
