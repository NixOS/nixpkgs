{ lib, stdenv, fetchFromGitHub, cmake, scdoc, util-linux, xorg }:

stdenv.mkDerivation rec {
  pname = "ydotool";
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "ReimuNotMoe";
    repo = "ydotool";
    rev = "v${version}";
    hash = "sha256-MtanR+cxz6FsbNBngqLE+ITKPZFHmWGsD1mBDk0OVng=";
  };

  postPatch = ''
    substituteInPlace Daemon/ydotoold.c \
      --replace "/usr/bin/xinput" "${xorg.xinput}/bin/xinput"
    substituteInPlace Daemon/ydotool.service.in \
      --replace "/usr/bin/kill" "${util-linux}/bin/kill"
  '';

  strictDeps = true;
  nativeBuildInputs = [ cmake scdoc ];

  meta = with lib; {
    homepage = "https://github.com/ReimuNotMoe/ydotool";
    description = "Generic Linux command-line automation tool";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ willibutz kraem ];
    platforms = with platforms; linux;
  };
}
