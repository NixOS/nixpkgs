{
  fetchFromGitHub,
  rustPlatform,
  lib,
  nix-update-script,
}:
rustPlatform.buildRustPackage rec {
  pname = "scx-loader";
  version = "1.1.1";

  cargoHash = "sha256-uX2lCVDa8eAKWi/bj94+JQHoOLll0OjKRHT0EPZELNc=";

  src = fetchFromGitHub {
    owner = "sched-ext";
    repo = "scx-loader";
    tag = "v${version}";
    hash = "sha256-5OvdtW/Li+ubHDBSKe2ssE9ZyNSCcxNFSJffzxQ9WMk=";
  };

  postInstall = ''
    VENDOR_PREFIX="" VENDOR_DATADIR="/share" cargo xtask install --destdir $out
    rm $out/bin/xtask
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
