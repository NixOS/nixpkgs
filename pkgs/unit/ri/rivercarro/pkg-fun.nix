{ lib
, stdenv
, fetchFromSourcehut
, zig
, river
, wayland
, pkg-config
}:

stdenv.mkDerivation rec {
  pname = "rivercarro";
  version = "0.1.4";

  src = fetchFromSourcehut {
    owner = "~novakane";
    repo = pname;
    fetchSubmodules = true;
    rev = "v${version}";
    sha256 = "sha256-eATbbwIt5ytEVLPodyq9vFF9Rs5S1xShpvNYQnfwdV4=";
  };

  nativeBuildInputs = [
    pkg-config
    river
    wayland
    zig
  ];

  dontConfigure = true;

  preBuild = ''
    export HOME=$TMPDIR
  '';

  installPhase = ''
    runHook preInstall
    zig build -Drelease-safe -Dcpu=baseline --prefix $out install
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://git.sr.ht/~novakane/rivercarro";
    description = "A layout generator for river Wayland compositor, fork of rivertile";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ kraem ];
  };
}

