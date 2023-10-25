{ lib
, rustPlatform
, fetchFromGitHub
, cmake
, pkg-config
, wrapGAppsHook
, atk
, glib
, gtk3-x11
, nix-update-script
}:

rustPlatform.buildRustPackage rec {
  pname = "ukmm";
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "NiceneNerd";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-suxUiJ++39aJe5XmAqh5sQajLzYoXo06k9mYw9rLU9E=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "catppuccin-egui-1.0.2" = "sha256-+ILfvDgZxe/QPJuVqIbRjaHNovpRAX+ym2QZ96glb4w=";
      "ecolor-0.20.0" = "sha256-uTDkNRWsA1nM8Qhb0X2LjVDRuaW31vWxR8kDLL27BVE=";
      "egui-notify-0.4.0" = "sha256-jybtUnv9xqzulZ5nfg+T1u8iTOsPjKGVVQ7JhwbvPdU=";
      "egui_commonmark-0.6.0" = "sha256-hsVbtL2F+jifnzN6FgcDAVtLd1bVxTs0twn0SMvq9eU=";
      "egui_dock-0.2.1" = "sha256-gGIO0boXKxLu0ABDH/uJhEZEoE/ql8E65LRmr0Xhv3s=";
      "junction-0.2.0" = "sha256-6+pPp5wG1NoIj16Z+OvO4Pvy0jnQibn/A9cTaHAEVq4=";
      "msbt-0.1.1" = "sha256-PtBs60xgYrwS7yPnRzXpExwYUD3azIaqObRnnJEL5dE=";
      "msyt-1.2.1" = "sha256-aw5whCoQBhO0u9Fx2rTO1sRuPdGnAAlmPWv5q8CbQcI=";
    };
  };

  RUSTC_BOOTSTRAP = true;

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapGAppsHook
  ];

  buildInputs = [
    atk
    glib
    gtk3-x11
  ];

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
    description = "A new mod manager for The Legend of Zelda: Breath of the Wild";
    homepage = "https://github.com/NiceneNerd/ukmm";
    changelog = "https://github.com/NiceneNerd/ukmm/blob/${src.rev}/CHANGELOG.md";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ kira-bruneau ];
    platforms = platforms.linux;
  };
}
