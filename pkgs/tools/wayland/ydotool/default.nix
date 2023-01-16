{ lib, stdenv, fetchFromGitHub, cmake, scdoc, util-linux }:

stdenv.mkDerivation rec {
  pname = "ydotool";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "ReimuNotMoe";
    repo = "ydotool";
    rev = "v${version}";
    sha256 = "sha256-RcPHQFXD3YgfF11OFpcnSowPlEjxy2c2RWhGYr30GhI=";
  };

  strictDeps = true;
  nativeBuildInputs = [ cmake scdoc ];

  postInstall = ''
    substituteInPlace ${placeholder "out"}/lib/systemd/user/ydotool.service \
      --replace /usr/bin/kill "${util-linux}/bin/kill"
  '';

  meta = with lib; {
    homepage = "https://github.com/ReimuNotMoe/ydotool";
    description = "Generic Linux command-line automation tool";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ willibutz kraem ];
    platforms = with platforms; linux;
  };
}
