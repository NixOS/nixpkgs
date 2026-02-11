{
  fetchFromGitHub,
  rustPlatform,
  lib,
  nix-update-script,
}:
rustPlatform.buildRustPackage rec {
  pname = "scx-loader";
  version = "1.1.0";

  cargoHash = "sha256-dw1Y2BAqb47HeJVEkznCh0IPNgrhvBYrWKUyI8H+xoU=";

  src = fetchFromGitHub {
    owner = "sched-ext";
    repo = "scx-loader";
    tag = "v${version}";
    hash = "sha256-B66+Awt+q3GuriRSFWmGKh6GicQiPlpQMPlpwbItUrk=";
  };

  postInstall = ''
    install -Dm444 services/org.scx.Loader.service -t $out/share/dbus-1/system-services/
    install -Dm444 configs/org.scx.Loader.conf -t $out/share/dbus-1/system.d/
    install -Dm444 configs/org.scx.Loader.xml -t $out/share/dbus-1/interfaces/
    install -Dm444 configs/org.scx.Loader.policy -t $out/share/polkit-1/actions/
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    mainProgram = "scx_loader";
    homepage = "https://github.com/sched-ext/scx-loader";
    changelog = "https://github.com/sched-ext/scx-loader/releases/tag/v${version}";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    badPlatforms = [ "aarch64-linux" ];
    maintainers = with lib.maintainers; [
      name-tar-xz
      Gliczy
      michaelBelsanti
    ];
  };
}
