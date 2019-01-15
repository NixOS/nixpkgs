{ stdenv, fetchFromGitHub, perl }:

stdenv.mkDerivation rec {
  name = "inxi-${version}";
  version = "3.0.30-1";

  src = fetchFromGitHub {
    owner = "smxi";
    repo = "inxi";
    rev = version;
    sha256 = "04dkws3716clscl6iq3sy6m822rqzwdg5mn03l0vhcdbqcng46s6";
  };

  buildInputs = [ perl ];

  installPhase = ''
    mkdir -p $out/bin
    cp inxi $out/bin/
    mkdir -p $out/share/man/man1
    cp inxi.1 $out/share/man/man1/
  '';

  meta = with stdenv.lib; {
    description = "A full featured CLI system information tool";
    homepage = https://smxi.org/docs/inxi.htm;
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ primeos ];
  };
}
