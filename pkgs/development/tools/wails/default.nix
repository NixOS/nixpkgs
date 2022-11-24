{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
, pkg-config
, makeWrapper
, go
, gcc
, gtk3
, webkitgtk
, nodejs
, zlib
}:

buildGoModule rec {
  pname = "wails";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "wailsapp";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-g5tZUVOZ2ywD2vS9B3y3GHaoABr2rSIZGUOsdUJOL8Q=";
  } + "/v2";

  vendorSha256 = "sha256-jRW8SROt0CON17xZ+I3WiQow7yC1ly7pPHgbpEr1kW8=";

  proxyVendor = true;

  subPackages = [ "cmd/wails" ];

  # These packages are needed to build wails
  # and will also need to be used when building a wails app.
  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];

  # Wails apps are built with Go, so we need to be able to
  # add it in propagatedBuildInputs.
  allowGoReference = true;

  # Following packages are required when wails used as a builder.
  propagatedBuildInputs = [
    pkg-config
    go
    gcc
    gtk3
    webkitgtk
    nodejs
  ];

  ldflags = [
    "-s"
    "-w"
  ];

  # As Wails calls a compiler, certain apps and libraries need to be made available.
  postFixup = ''
    wrapProgram $out/bin/wails \
      --prefix PATH : ${lib.makeBinPath [ pkg-config go gcc nodejs ]} \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ gtk3 webkitgtk ]} \
      --set PKG_CONFIG_PATH "$PKG_CONFIG_PATH" \
      --set CGO_LDFLAGS "-L${lib.makeLibraryPath [ zlib ]}"
  '';

  meta = with lib; {
    description = "Build applications using Go + HTML + CSS + JS";
    homepage = "https://wails.io";
    license = licenses.mit;
    maintainers = with maintainers; [ ianmjones ];
    platforms = platforms.linux;
  };
}
