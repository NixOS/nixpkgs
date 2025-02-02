{ lib
, rustPlatform
, fetchFromGitHub
, cmake
, pkg-config
, wrapGAppsHook3
, libglvnd
, nix-update-script
}:

rustPlatform.buildRustPackage rec {
  pname = "ukmm";
  version = "0.11.1";

  src = fetchFromGitHub {
    owner = "NiceneNerd";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-yxF08kTA/IhM3LKFH523kVY3QfqwUElz3ICkjKPAo7E=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "egui-aesthetix-0.2.2" = "sha256-LtrMSnz5KWUrYCe50kgGU98WdPxWlo+U7FtRmxSIeI8=";
      "junction-0.2.0" = "sha256-6+pPp5wG1NoIj16Z+OvO4Pvy0jnQibn/A9cTaHAEVq4=";
      "msbt-0.1.1" = "sha256-PtBs60xgYrwS7yPnRzXpExwYUD3azIaqObRnnJEL5dE=";
      "msyt-1.2.1" = "sha256-aw5whCoQBhO0u9Fx2rTO1sRuPdGnAAlmPWv5q8CbQcI=";
    };
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapGAppsHook3
  ];

  preFixup = ''
    gappsWrapperArgs+=(--prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ libglvnd ]})
  '';

  cargoTestFlags = [
    "--all"
  ];

  checkFlags = [
    # Requires a game dump of Breath of the Wild
    "--skip=gui::tasks::tests::remerge"
    "--skip=pack::tests::pack_mod"
    "--skip=project::tests::project_from_mod"
    "--skip=tests::read_meta"
    "--skip=unpack::tests::read_mod"
    "--skip=unpack::tests::unpack_mod"
    "--skip=unpack::tests::unzip_mod"

    # Requires Clear Camera mod
    "--skip=bnp::test_convert"
  ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "New mod manager for The Legend of Zelda: Breath of the Wild";
    homepage = "https://github.com/NiceneNerd/ukmm";
    changelog = "https://github.com/NiceneNerd/ukmm/blob/${src.rev}/CHANGELOG.md";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ kira-bruneau ];
    platforms = platforms.linux;
    mainProgram = "ukmm";
  };
}
