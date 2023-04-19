{
  stdenv, lib, fetchFromGitHub, pkg-config, buildGoModule,
  libGL, libX11, libXcursor, libXfixes, libxkbcommon, vulkan-headers, wayland,
}:

buildGoModule rec {
  pname = "gotraceui";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "dominikh";
    repo = "gotraceui";
    rev = "v${version}";
    sha256 = "sha256-KgDQ0lL3J1QT5Oij+4Nu3wpzvGiCTaOTIBTd5WJhhz8=";
  };

  vendorSha256 = "sha256-qnHU/Ht5+BGVoGbz2h9/k3gD1L2qAW0eZJ2xBzJatHQ=";
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
