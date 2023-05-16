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
<<<<<<< HEAD
  version = "2.6.0";
=======
  version = "2.4.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "wailsapp";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-jY+2I4SOr6gr2MCLrBBE9H0T1sTB13kEb1OJ717kWqg=";
  } + "/v2";

  vendorHash = "sha256-56LZQQzfFQTa4fo5bdZtK/VzNDBPyI9hDG4RkP38gcI=";
=======
    sha256 = "sha256-ei+bp4fwlxZ9ZiXW/FqpqICXpFxpmOKkZZYW0LxHh1s=";
  } + "/v2";

  vendorSha256 = "sha256-RiectpUhm24xjgfPZEMDVFSEzPtIjn7L/qC2KE2s5aw=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
