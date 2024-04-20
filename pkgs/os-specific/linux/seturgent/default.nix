{ lib, stdenv, fetchgit, libX11, xorgproto }:

stdenv.mkDerivation rec {
  pname = "seturgent";
  version = "1.5";

  src = fetchgit {
    url = "git://git.codemadness.org/seturgent";
    rev = version;
    sha256 = "sha256-XW7ms0BVCf1/fuL3PJ970t6sHkmMY1iLYXfS9R60JX0=";
  };

  buildInputs = [
    libX11
    xorgproto
  ];

  installPhase = ''
    mkdir -pv $out/bin
    mv seturgent $out/bin
  '';

  meta = with lib; {
    platforms = platforms.linux;
    description = "Set an application's urgency hint (or not)";
    mainProgram = "seturgent";
    maintainers = with maintainers; [ yarr ];
    homepage = "https://codemadness.org/seturgent-set-urgency-hints-for-x-applications.html";
    license = licenses.mit;
  };
}
