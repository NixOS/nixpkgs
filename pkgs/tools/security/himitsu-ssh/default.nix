{ lib
, stdenv
, fetchFromSourcehut
, hare
, hareThirdParty
, himitsu
, scdoc
}:

stdenv.mkDerivation rec {
  pname = "himitsu-ssh";
  version = "unstable-2023-12-05";

  src = fetchFromSourcehut {
    name = pname + "-src";
    owner = "~sircmpwn";
    repo = pname;
    rev = "09b33fef81617fae200d8853cc18adb9ebc62119";
    hash = "sha256-2bv3MPl4m7oVDdrL0ZuFq5mmPRGWlb0uzby1sE/XDEA=";
  };

  nativeBuildInputs = [
    hare
    hareThirdParty.hare-ssh
    scdoc
  ];

  buildInputs = [
    himitsu
  ];

  preConfigure = ''
    export HARECACHE=$(mktemp -d)
  '';

  installFlags = [ "PREFIX=" "DESTDIR=$(out)" ];

  meta = with lib; {
    homepage = "https://git.sr.ht/~sircmpwn/himitsu-ssh";
    description = "Himitsu integration for SSH";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ patwid ];
    inherit (hare.meta) platforms badPlatforms;
  };
}
