{ lib, stdenv, fetchFromGitHub, autoconf, automake, ncurses, SDL, gpm, miniupnpc }:

stdenv.mkDerivation rec {
  pname = "qodem";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "klamonte";
    repo = "qodem";
    rev = "v${version}";
    sha256 = "NAdcTVmNrDa3rbsbxJxFoI7sz5NK5Uw+TbP+a1CdB+Q=";
  };

  nativeBuildInputs = [ autoconf automake ];
  buildInputs = [ ncurses SDL gpm miniupnpc ];

  meta = with lib; {
    homepage = "https://qodem.sourceforge.net/";
    description = "Re-implementation of the DOS-era Qmodem serial communications package";
    longDescription = ''
      Qodem is a from-scratch clone implementation of the Qmodem
      communications program made popular in the days when Bulletin Board
      Systems ruled the night. Qodem emulates the dialing directory and the
      terminal screen features of Qmodem over both modem and Internet
      connections.
    '';
    maintainers = with maintainers; [ embr ];
    license = licenses.publicDomain;
  };
}
