{ lib
, fetchFromGitHub
, makeWrapper
, rustPlatform
, vulkan-loader
, wayland
, pkg-config
, udev
, v4l-utils
}:

rustPlatform.buildRustPackage rec {
  pname = "wluma";
  version = "4.2.0";

  src = fetchFromGitHub {
    owner = "maximbaz";
    repo = "wluma";
    rev = version;
    sha256 = "sha256-6qZlwjzBPDkr2YHzDYeKQOuoozV7rpl8dojqTTzInqg=";
  };

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
  ];

  buildInputs = [
    udev
    v4l-utils
    vulkan-loader
  ];

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
  };
}
