{ stdenv
, lib
, fetchgit
, xorg
}:

stdenv.mkDerivation rec {
  pname = "drawterm";
  version = "unstable-2021-10-02";

  src = fetchgit {
    url = "git://git.9front.org/plan9front/drawterm";
    rev = "c6f547e1a46ebbf7a290427fe3a0b66932d671a0";
    sha256 = "09v2vk5s23q0islfz273pqy696zhzh3gqi25hadr54lif0511wsl";
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
