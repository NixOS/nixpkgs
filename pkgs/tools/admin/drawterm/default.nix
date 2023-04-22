{ stdenv
, lib
, fetchgit
, xorg
}:

stdenv.mkDerivation rec {
  pname = "drawterm";
  version = "unstable-2023-03-05";

  src = fetchgit {
    url = "git://git.9front.org/plan9front/drawterm";
    rev = "ed9cff5a4c39322744c4708699c9ae6651b7c9ab";
    sha256 = "LM6UnggoxKC3e6xOlHYk9VFF99Abbdmp37nuUML8RgI=";
  };

  buildInputs = [
    xorg.libX11
    xorg.libXt
  ];

  # TODO: macos
  makeFlags = [ "CONF=unix" ];

  installPhase = ''
    install -Dm755 -t $out/bin/ drawterm
    install -Dm644 -t $out/man/man1/ drawterm.1
  '';

  meta = with lib; {
    description = "Connect to Plan9 CPU servers from other operating systems.";
    homepage = "https://drawterm.9front.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ luc65r ];
    platforms = platforms.linux;
  };
}
