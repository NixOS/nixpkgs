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
, upx
, zlib
}:

buildGoModule rec {
  pname = "wails";
  version = "2.0.0-beta.36";

  src = fetchFromGitHub {
    owner = "wailsapp";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-uAbVc1UDgSNJwk8R6zXXqZImo6J9TRs3zPNlWelXS/I=";
  } + "/v2";

  vendorSha256 = "sha256-rrwlFZQT7sHhUqtU4UzwEqZbjWd/1fudfj/xdTGFUmQ=";

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
    upx
  ];

  ldflags = [
    "-s"
    "-w"
  ];

  # As Wails calls a compiler, certain apps and libraries need to be made available.
  postFixup = ''
    wrapProgram $out/bin/wails \
      --prefix PATH : ${lib.makeBinPath [ pkg-config go gcc nodejs upx ]} \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ gtk3 webkitgtk ]} \
      --set PKG_CONFIG_PATH "$PKG_CONFIG_PATH" \
      --set CGO_LDFLAGS "-L${lib.makeLibraryPath [ zlib ]}"
  '';

  doCheck = true;

  meta = with lib; {
    description = "Build applications using Go + HTML + CSS + JS";
    homepage = "https://wails.io";
    license = licenses.mit;
    maintainers = with maintainers; [ ianmjones ];
    platforms = platforms.linux;
  };
}
