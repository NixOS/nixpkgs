{ fetchCrate
, installShellFiles
, lib
, libbsd
, pkg-config
, rustPlatform
, stdenv
}:

rustPlatform.buildRustPackage rec {
  pname = "inputplug";
  version = "0.4.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-8Gy0h0QMcittnjuKm+atIJNsY2d6Ua29oab4fkUU+wE=";
  };

  nativeBuildInputs = [ installShellFiles pkg-config ];

  buildInputs = [ libbsd ];

  cargoHash = "sha256-W6LvdjR3jTf08X75wPWloLx7FUYTpboB3E5f0g75M5g=";

  postInstall = ''
    installManPage inputplug.1
  '';

  meta = with lib; {
    description = "Monitor XInput events and run arbitrary scripts on hierarchy change events";
    homepage = "https://github.com/andrewshadura/inputplug";
    license = licenses.mit;
    platforms = platforms.unix;
    # `daemon(3)` is deprecated on macOS and `pidfile-rs` needs updating
    broken = stdenv.isDarwin;
    maintainers = with maintainers; [ jecaro ];
    mainProgram = "inputplug";
  };
}

