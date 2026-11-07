{ lib, pkgs, ... }:
let
  nixpkgsFun = import ../../top-level;
in
lib.recurseIntoAttrs {
  platformEquality =
    let
      configsLocal = [
        # crossSystem is implicitly set to localSystem.
        {
          localSystem = {
            system = "x86_64-linux";
          };
        }
        {
          localSystem = {
            system = "aarch64-linux";
          };
          crossSystem = null;
        }
        # Both systems explicitly set to the same string.
        {
          localSystem = {
            system = "x86_64-linux";
          };
          crossSystem = {
            system = "x86_64-linux";
          };
        }
        # Vendor and ABI inferred from system double.
        {
          localSystem = {
            system = "aarch64-linux";
          };
          crossSystem = {
            config = "aarch64-unknown-linux-gnu";
          };
        }
      ];
      configsCross = [
        # GNU is inferred from double, but config explicitly requests musl.
        {
          localSystem = {
            system = "aarch64-linux";
          };
          crossSystem = {
            config = "aarch64-unknown-linux-musl";
          };
        }
        # Cross-compile from AArch64 to x86-64.
        {
          localSystem = {
            system = "aarch64-linux";
          };
          crossSystem = {
            system = "x86_64-unknown-linux-gnu";
          };
        }
      ];

      pkgsLocal = map nixpkgsFun configsLocal;
      pkgsCross = map nixpkgsFun configsCross;
    in
    assert lib.all (p: p.stdenv.buildPlatform == p.stdenv.hostPlatform) pkgsLocal;
    assert lib.all (p: p.stdenv.buildPlatform != p.stdenv.hostPlatform) pkgsCross;
    pkgs.emptyFile;

  # appendOverlays must preserve splicing so that cross-compilation
  # works in NixOS modules (which go through appendOverlays via nixpkgs.nix).
  appendOverlaysPreservesSplicing =
    let
      cross = nixpkgsFun {
        localSystem = {
          system = "x86_64-linux";
        };
        crossSystem = {
          system = "aarch64-linux";
        };
      };
      appended = cross.appendOverlays [ ];
    in
    assert cross.makeWrapper ? __spliced;
    assert appended.makeWrapper ? __spliced;
    pkgs.emptyFile;

  replaceStdenv =
    let
      replacedPkgs = nixpkgsFun {
        localSystem = {
          inherit (pkgs.stdenv.buildPlatform) system;
        };
        config.replaceStdenv =
          { pkgs }:
          assert !(pkgs.config ? replaceStdenv);
          pkgs.stdenv
          // {
            wasReplaced = true;
          };
      };
    in
    assert replacedPkgs.stdenv.wasReplaced;
    pkgs.emptyFile;

  replaceStdenvIgnoredForCross =
    let
      crossPkgs = nixpkgsFun {
        localSystem = {
          system = "x86_64-linux";
        };
        crossSystem = {
          system = "aarch64-linux";
        };
        config.replaceStdenv = _: throw "replaceStdenv must be ignored when cross compiling";
      };
    in
    assert crossPkgs.stdenv.buildPlatform != crossPkgs.stdenv.hostPlatform;
    pkgs.emptyFile;

  massRebuildVariantComposition =
    let
      variants = [
        "pkgsChecked"
        "pkgsParallel"
        "pkgsStrict"
        "pkgsStructured"
      ];
      all = lib.getAttrFromPath variants pkgs;
      all-reversed = lib.getAttrFromPath (lib.reverseList variants) pkgs;
    in
    assert pkgs.config.allowVariants -> (all.hello == all-reversed.hello);
    pkgs.emptyFile;

  # `makeDesktopItem`'s `passthru` and file-parsed info have to agree
  desktopEntries =
    let
      inherit (import ../../top-level/desktop-entries.nix { inherit lib; })
        entriesOf
        parseDesktopEntry
        ;

      item = pkgs.makeDesktopItem {
        name = "test-entry";
        desktopName = "Test Entry";
        genericName = "Tester";
        comment = "Exercises the desktop entry index";
        exec = "test-entry %U";
        icon = "test-entry";
        keywords = [
          "one"
          "two"
        ];
        mimeTypes = [
          "text/plain"
          "x-scheme-handler/test"
        ];
        categories = [
          "Utility"
          "Development"
        ];
        noDisplay = true;
        extraConfig = {
          "Name[de]" = "Testeintrag";
          "Comment[de]" = "Uebt den Index";
          "Keywords[de]" = "eins;zwei";
          "X-Test-Not-Localized" = "ignored";
        };
      };

      # Entries not from `makeDesktopItem` won't expose their info by `passthru`
      rendered = pkgs.writeText "test-entry.desktop" item.text;

      entry = {
        type = "Application";
        desktopName = "Test Entry";
        genericName = "Tester";
        comment = "Exercises the desktop entry index";
        icon = "test-entry";
        keywords = [
          "one"
          "two"
        ];
        mimeTypes = [
          "text/plain"
          "x-scheme-handler/test"
        ];
        categories = [
          "Utility"
          "Development"
        ];
        noDisplay = true;
        localized.de = {
          desktopName = "Testeintrag";
          comment = "Uebt den Index";
          keywords = [
            "eins"
            "zwei"
          ];
        };
      };

      tests = {
        passthru = {
          expr = entriesOf { desktopItems = [ item ]; };
          expected = [ entry ];
        };

        # The rendered file must parse back to what the passthru gave
        renderedFallback = {
          expr = entriesOf { desktopItems = [ rendered ]; };
          expected = [ entry ];
        };

        # `desktopItems` is not always a list; some packages assign a bare item
        bareItem = {
          expr = entriesOf { desktopItems = item; };
          expected = [ entry ];
        };

        # The other way an item reaches a package
        passthruDesktopItem = {
          expr = entriesOf { passthru.desktopItem = item; };
          expected = [ entry ];
        };

        # A plain path into `$src` has nothing to read, so it is skipped
        plainPath = {
          expr = entriesOf { desktopItems = [ "share/applications/test-entry.desktop" ]; };
          expected = [ ];
        };

        # What almost every package is
        noItems = {
          expr = entriesOf { };
          expected = [ ];
        };

        # A trailing action section must not leak into the entry
        firstSectionOnly = {
          expr =
            (parseDesktopEntry ''
              [Desktop Entry]
              Type=Application
              Name=First

              [Desktop Action new]
              Name=Second
            '').desktopName;
          expected = "First";
        };
      };

      failed = lib.filterAttrs (_: test: test.expr != test.expected) tests;
    in
    assert lib.assertMsg (failed == { }) ''
      tests.top-level.desktopEntries: ${lib.concatStringsSep ", " (lib.attrNames failed)} failed
      ${lib.generators.toPretty { } failed}'';
    pkgs.emptyFile;
}
