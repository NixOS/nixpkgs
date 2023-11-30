{ lib
, stdenv
, xorg
, pkg-config
, fetchFromGitHub
, autoreconfHook
}:

stdenv.mkDerivation rec {
  pname = "xplugd";
  version = "1.4";

  src = fetchFromGitHub {
    owner = "troglobit";
    repo = "xplugd";
    rev = "v${version}";
    sha256 = "11vjr69prrs4ir9c267zwq4g9liipzrqi0kmw1zg95dbn7r7zmql";
  };

  buildInputs = with xorg; [ libX11 libXi libXrandr libXext ];
  nativeBuildInputs = [ pkg-config autoreconfHook ];

  meta = with lib; {
    homepage = "https://github.com/troglobit/xplugd";
    description = "A UNIX daemon that executes a script on X input and RandR changes";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ akho ];
    mainProgram = "xplugd";
  };
}
