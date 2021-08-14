{ stdenv
, lib
, fetchgit
, xorg
}:

stdenv.mkDerivation rec {
  pname = "drawterm";
  version = "unstable-2021-08-02";

  src = fetchgit {
    url = "git://git.9front.org/plan9front/drawterm";
    rev = "a130d441722ac3f759d2d83b98eb6aef7e84f97e";
    sha256 = "R+W1XMqQqCrMwgX9lHRhxJPG6ZOvtQrU6HUsKfvfrBQ=";
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
