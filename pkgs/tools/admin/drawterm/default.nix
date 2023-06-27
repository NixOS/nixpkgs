{ stdenv
, lib
, fetchgit
, xorg
}:

stdenv.mkDerivation rec {
  pname = "drawterm";
  version = "unstable-2023-06-27";

  src = fetchgit {
    url = "git://git.9front.org/plan9front/drawterm";
    rev = "36debf46ac184a22c6936345d22e4cfad995948c";
    sha256 = "ebqw1jqeRC0FWeUIO/HaEovuwzU6+B48TjZbVJXByvA=";
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
