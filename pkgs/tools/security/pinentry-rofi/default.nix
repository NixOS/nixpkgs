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
  version = "2.0.5";

  src = fetchFromGitHub {
    owner = "plattfot";
    repo = pname;
    rev = version;
    sha256 = "sha256-6dhzzxjE3GE5JZTirMLeMh91BS2wzDZoubgf4Wefe1o=";
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
    mainProgram = "pinentry-rofi";
  };
}
