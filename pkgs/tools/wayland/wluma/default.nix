{ lib
, stdenv
, fetchFromGitHub
, makeWrapper
, rustPlatform
, marked-man
, coreutils
, vulkan-loader
, wayland
, pkg-config
, udev
, v4l-utils
}:

rustPlatform.buildRustPackage rec {
  pname = "wluma";
  version = "4.3.0";

  src = fetchFromGitHub {
    owner = "maximbaz";
    repo = "wluma";
    rev = version;
    sha256 = "sha256-FaX87k8LdBhrBX4qvokSHkcNaQZ0+oSbkn9d0dK6FGo=";
  };

  postPatch = ''
    substituteInPlace Makefile --replace \
      'target/release/$(BIN)' \
      'target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/$(BIN)'

    # Needs chmod and chgrp
    substituteInPlace 90-wluma-backlight.rules --replace \
      'RUN+="/bin/' 'RUN+="${coreutils}/bin/'

    substituteInPlace wluma.service --replace \
      'ExecStart=/usr/bin/wluma' 'ExecStart=${placeholder "out"}/bin/wluma'
  '';

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "toml-0.5.9" = "sha256-WUQFF9Hfo3JK65AKAF7qNZex6l7F3N8HXmJlu8cJUEE=";
    };
  };

  nativeBuildInputs = [
    makeWrapper
    pkg-config
    rustPlatform.bindgenHook
    marked-man
  ];

  buildInputs = [
    udev
    v4l-utils
    vulkan-loader
  ];

  postBuild = ''
    make docs
  '';

  dontCargoInstall = true;
  installFlags = [ "PREFIX=${placeholder "out"}" ];
  postInstall = ''
    wrapProgram $out/bin/wluma \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ wayland ]}"
  '';

  meta = with lib; {
    description = "Automatic brightness adjustment based on screen contents and ALS";
    homepage = "https://github.com/maximbaz/wluma";
    changelog = "https://github.com/maximbaz/wluma/releases/tag/${version}";
    license = licenses.isc;
    maintainers = with maintainers; [ yshym jmc-figueira ];
    platforms = platforms.linux;
    mainProgram = "wluma";
  };
}
