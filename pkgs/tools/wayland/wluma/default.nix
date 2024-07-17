{
  lib,
  fetchFromGitHub,
  makeWrapper,
  rustPlatform,
  vulkan-loader,
  wayland,
  pkg-config,
  udev,
  v4l-utils,
  dbus,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "wluma";
  version = "4.4.0";

  src = fetchFromGitHub {
    owner = "maximbaz";
    repo = "wluma";
    rev = version;
    sha256 = "sha256-Ow3SjeulYiHY9foXrmTtLK3F+B3+DrtDjBUke3bJeDw=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
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
    dbus
  ];

  postInstall = ''
    wrapProgram $out/bin/wluma \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ wayland ]}"
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Automatic brightness adjustment based on screen contents and ALS";
    homepage = "https://github.com/maximbaz/wluma";
    changelog = "https://github.com/maximbaz/wluma/releases/tag/${version}";
    license = licenses.isc;
    maintainers = with maintainers; [
      yshym
      jmc-figueira
      atemu
    ];
    platforms = platforms.linux;
    mainProgram = "wluma";
  };
}
