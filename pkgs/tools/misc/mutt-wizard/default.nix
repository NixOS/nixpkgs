{ lib
, stdenvNoCC
, fetchFromGitHub
}:

stdenvNoCC.mkDerivation rec {
  pname = "mutt-wizard";
  version = "3.2.1";

  src = fetchFromGitHub {
    owner = "LukeSmithxyz";
    repo = "mutt-wizard";
    rev = "v${version}";
    sha256 = "1m4s0vj57hh38rdgdc28p10vnsq80dh708imvdgxbj1i96nq41r8";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    description = "System for automatically configuring mutt and isync";
    homepage = "https://github.com/LukeSmithxyz/mutt-wizard";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ shamilton ];
    platforms = platforms.unix;
  };
}
