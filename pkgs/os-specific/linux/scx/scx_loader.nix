{
  fetchFromGitHub,
  rustPlatform,
  lib,
  nix-update-script,
}:
rustPlatform.buildRustPackage rec {
  pname = "scx-loader";
  version = "1.0.19";

  cargoHash = "sha256-JD/oAFA/2kBvWTKq6yYOX8dl/hixkJyo9BqhBUu9sM0=";

  src = fetchFromGitHub {
    owner = "sched-ext";
    repo = "scx-loader";
    tag = "v${version}";
    hash = "sha256-lF3kRDPGI5x3GlGlVzSA/U9SI0/KjUry/eXZpM12bIg=";
  };

  postInstall = ''
    install -Dm644 services/org.scx.Loader.service -t $out/share/dbus-1/system-services/
    install -Dm644 configs/org.scx.Loader.conf -t $out/share/dbus-1/system.d/
    install -Dm644 configs/org.scx.Loader.xml -t $out/share/dbus-1/interfaces/
    install -Dm644 configs/org.scx.Loader.policy -t $out/share/polkit-1/actions/
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    mainProgram = "scx_loader";
    homepage = "https://github.com/sched-ext/scx-loader/tree/main/scheds/rust";
    changelog = "https://github.com/sched-ext/scx-loader/releases/tag/v${version}";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    badPlatforms = [ "aarch64-linux" ];
  };
}
