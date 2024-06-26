{
  fetchCrate,
  installShellFiles,
  lib,
  libbsd,
  pkg-config,
  rustPlatform,
  stdenv,
}:

rustPlatform.buildRustPackage rec {
  pname = "inputplug";
  version = "0.4.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "00gv2i2pxy56l6ysslbscxinr4r0mpk9p2ivkrnjnwhc8j3v8v7h";
  };

  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ];

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
