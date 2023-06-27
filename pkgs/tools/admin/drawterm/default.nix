{ stdenv
, lib
, fetchgit
, installShellFiles
, xorg
, pkg-config
, wayland-scanner
, pipewire
, wayland
, wayland-protocols
, libxkbcommon
, wlr-protocols
, config
}:

stdenv.mkDerivation rec {
  pname = "drawterm";
  version = "unstable-2023-06-27";

  src = fetchgit {
    url = "git://git.9front.org/plan9front/drawterm";
    rev = "36debf46ac184a22c6936345d22e4cfad995948c";
    sha256 = "ebqw1jqeRC0FWeUIO/HaEovuwzU6+B48TjZbVJXByvA=";
  };

  nativeBuildInputs = [ installShellFiles ] ++ {
    linux = [ pkg-config wayland-scanner ];
    unix = [];
  }."${config}" or (throw "unsupported CONF");


  buildInputs = {
    linux = [ pipewire wayland wayland-protocols libxkbcommon wlr-protocols ];
    unix = [ xorg.libX11 xorg.libXt ];
  }."${config}" or (throw "unsupported CONF");

  # TODO: macos
  makeFlags = [ "CONF=${config}" ];

  installPhase = ''
    install -Dm755 -t $out/bin/ drawterm
    installManPage drawterm.1
  '';

  meta = with lib; {
    description = "Connect to Plan 9 CPU servers from other operating systems.";
    homepage = "https://drawterm.9front.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ luc65r moody ];
    platforms = platforms.linux;
  };
}
