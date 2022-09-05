{ stdenv
, lib
, fetchFromGitHub
, pkg-config
, autoreconfHook
, autoconf-archive
, guile
, texinfo
, rofi
}:

stdenv.mkDerivation rec {
  pname = "pinentry-rofi";
  version = "2.0.3";

  src = fetchFromGitHub {
    owner = "plattfot";
    repo = pname;
    rev = version;
    sha256 = "sha256-EzbeMAhdn9SuSmE+aMHeyuje3s74isIKRDTrFO3bX04=";
  };

  nativeBuildInputs = [
    autoconf-archive
    autoreconfHook
    pkg-config
    texinfo
  ];

  buildInputs = [ guile ];

  propagatedBuildInputs = [ rofi ];

  meta = with lib; {
    description = "Rofi frontend to pinentry";
    homepage = "https://github.com/plattfot/pinentry-rofi";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ seqizz ];
  };
}
