{
  stdenv, lib, fetchFromGitHub, pkg-config, buildGoModule,
  libGL, libX11, libXcursor, libXfixes, libxkbcommon, vulkan-headers, wayland,
}:

buildGoModule rec {
  pname = "gotraceui";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "dominikh";
    repo = "gotraceui";
    rev = "v${version}";
    sha256 = "sha256-dryDDunvxjHHzsMtTbEeIWqWOM7wtcyb9DjqzR2SgYE=";
  };

  vendorHash = "sha256-Nx91u2JOBWYiYeG4VbCYKg66GANDViVHrbE31YdPIzM=";
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
