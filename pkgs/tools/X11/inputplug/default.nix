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

  cargoSha256 = "161kz47d4psfvh0vm98k8qappg50lpsw1ybyy7s3g3bp6ivfz8jv";

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

