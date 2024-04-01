{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
, pkg-config
, makeWrapper
, go
, nodejs
, zlib
  # Linux specific dependencies
, gtk3
, webkitgtk
}:

buildGoModule rec {
  pname = "wails";
  version = "2.8.0";

  src = fetchFromGitHub {
    owner = "wailsapp";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-MHwIRanmgpjTKM+ILSQheCd9+XUwVTCVrREqntxpv7Q=";
  } + "/v2";

  vendorHash = "sha256-0cGmJEi7OfMZS7ObPBLHOVqKfvnlpHBiGRjSdV6wxE4=";

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
    stdenv.cc
    nodejs
  ] ++ lib.optionals stdenv.isLinux [
    gtk3
    webkitgtk
  ];

  ldflags = [
    "-s"
    "-w"
  ];

  # As Wails calls a compiler, certain apps and libraries need to be made available.
  postFixup = ''
    wrapProgram $out/bin/wails \
      --prefix PATH : ${lib.makeBinPath [ pkg-config go stdenv.cc nodejs ]} \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath (lib.optionals stdenv.isLinux [ gtk3 webkitgtk ])}" \
      --set PKG_CONFIG_PATH "$PKG_CONFIG_PATH" \
      --set CGO_LDFLAGS "-L${lib.makeLibraryPath [ zlib ]}"
  '';

  meta = {
    description = "Build applications using Go + HTML + CSS + JS";
    homepage = "https://wails.io";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ianmjones ];
    mainProgram = "wails";
    platforms = lib.platforms.unix;
  };
}
