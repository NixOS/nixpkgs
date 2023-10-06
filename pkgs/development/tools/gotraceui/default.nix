{
  stdenv, lib, fetchFromGitHub, pkg-config, buildGoModule,
  libGL, libX11, libXcursor, libXfixes, libxkbcommon, vulkan-headers, wayland,
}:

buildGoModule rec {
  pname = "gotraceui";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "dominikh";
    repo = "gotraceui";
    rev = "v${version}";
    sha256 = "sha256-hdI1TT33pPHK5018RQ+riPVqzqOF/xDkvh0WoYi6Pes=";
  };

  vendorHash = "sha256-nXPiwSG2Hs86/raDvTv2p77P6Xwm+t8VT0dvZpXE8Os=";
  subPackages = ["cmd/gotraceui"];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    vulkan-headers
    libxkbcommon
    wayland
    libX11
    libXcursor
    libXfixes
    libGL
  ];

  ldflags = ["-X gioui.org/app.ID=co.honnef.Gotraceui"];

  postInstall = ''
    cp -r share $out/
  '';

  meta = with lib; {
    description = "An efficient frontend for Go execution traces";
    homepage = "https://github.com/dominikh/gotraceui";
    platforms = platforms.linux;
    license = licenses.mit;
    maintainers = with maintainers; [ dominikh ];
  };
}
