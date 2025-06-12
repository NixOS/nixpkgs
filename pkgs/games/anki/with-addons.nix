{
  lib,
  symlinkJoin,
  makeWrapper,
  anki,
  anki-utils,
  writeTextDir,
  ankiAddons ? [ ],
}:
/*
  `ankiAddons`
   :  A set of Anki add-ons to be installed. Here's a an example:

      ~~~
      pkgs.anki.withAddons [
        # When the add-on is already available in nixpkgs
        pkgs.ankiAddons.anki-connect

        # When the add-on is not available in nixpkgs
        (pkgs.anki-utils.buildAnkiAddon (finalAttrs: {
          pname = "recolor";
          version = "3.1";
          src = pkgs.fetchFromGitHub {
            owner = "AnKing-VIP";
            repo = "AnkiRecolor";
            rev = finalAttrs.version;
            sparseCheckout = [ "src/addon" ];
            hash = "sha256-28DJq2l9DP8O6OsbNQCZ0pm4S6CQ3Yz0Vfvlj+iQw8Y=";
          };
          sourceRoot = "source/src/addon";
        }))

        # When the add-on needs to be configured
        pkgs.ankiAddons.passfail2.withConfig {
          config = {
            again_button_name = "not quite";
            good_button_name = "excellent";
          };

          user_files = ./dir-to-be-merged-into-addon-user-files-dir;
        };
      ]
      ~~~

      The original `anki` executable will be wrapped so that it uses the addons from
      `ankiAddons`.

      This only works with Anki versions patched to support the `ANKI_ADDONS` environment
      variable. `pkgs.anki` has this, but `pkgs.anki-bin` does not.
*/
let
  defaultAddons = [
    (anki-utils.buildAnkiAddon {
      pname = "nixos";
      version = "1.0";
      src = writeTextDir "__init__.py" ''
        import aqt
        from aqt.qt import QMessageBox
        import json

        def addons_dialog_will_show(dialog: aqt.addons.AddonsDialog) -> None:
          dialog.setEnabled(False)
          QMessageBox.information(
            dialog,
            "NixOS Info",
            ("These add-ons are managed by NixOS.<br>"
             "See <a href='https://github.com/NixOS/nixpkgs/tree/master/pkgs/games/anki/with-addons.nix'>"
             "github.com/NixOS/nixpkgs/tree/master/pkgs/games/anki/with-addons.nix</a>")
          )

        def addon_tried_to_write_config(module: str, conf: dict) -> None:
          message_box = QMessageBox(
            QMessageBox.Icon.Warning,
            "NixOS Info",
            (f"The add-on module: \"{module}\" tried to update its config.<br>"
              "See <a href='https://github.com/NixOS/nixpkgs/tree/master/pkgs/games/anki/with-addons.nix'>"
              "github.com/NixOS/nixpkgs/tree/master/pkgs/games/anki/with-addons.nix</a>"
              " for how to configure add-ons managed by NixOS.")
          )
          message_box.setDetailedText(json.dumps(conf))
          message_box.exec()

        aqt.gui_hooks.addons_dialog_will_show.append(addons_dialog_will_show)
        aqt.mw.addonManager.writeConfig = addon_tried_to_write_config
      '';
      meta.maintainers = with lib.maintainers; [ junestepp ];
    })
  ];
in
symlinkJoin {
  inherit (anki) version;
  pname = "${anki.pname}-with-addons";

  paths = [ anki ];

  nativeBuildInputs = [ makeWrapper ];
  postBuild = ''
    wrapProgram $out/bin/anki \
      --set ANKI_ADDONS "${anki-utils.buildAnkiAddonsDir (ankiAddons ++ defaultAddons)}"
  '';

  meta = builtins.removeAttrs anki.meta [
    "name"
    "outputsToInstall"
    "position"
  ];
}
