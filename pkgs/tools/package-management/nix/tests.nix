{
  runCommand,
  version,
  src,
  nix,
  lib,
  stdenv,
  pkgs,
  pkgsi686Linux,
  pkgsStatic,
  nixosTests,
  self_attribute_name,
}:
{
  srcVersion =
    runCommand "nix-src-version"
      {
        inherit version;
      }
      ''
        # This file is an implementation detail, but it's a good sanity check
        # If upstream changes that, we'll have to adapt.
        srcVersion=$(cat ${src}/.version)
        echo "Version in nix nix expression: $version"
        echo "Version in nix.src: $srcVersion"
        if [ "$version" != "$srcVersion" ]; then
          echo "Version mismatch!"
          exit 1
        fi
        touch $out
      '';

  /**
    Intended to test `lib`, but also a good smoke test for Nix
  */
  nixpkgs-lib = import ../../../../lib/tests/test-with-nix.nix {
    inherit lib pkgs;
    inherit nix;
  };
}
// lib.optionalAttrs stdenv.hostPlatform.isLinux {
  nixStatic = pkgsStatic.nixVersions.${self_attribute_name};

  # Basic smoke tests that needs to pass when upgrading nix.
  # Note that this test does only test the nixVersions.stable attribute.
  misc = nixosTests.nix-misc.default;
  upgrade = nixosTests.nix-upgrade;
  simpleUefiSystemdBoot = nixosTests.installer.simpleUefiSystemdBoot;
}
// lib.optionalAttrs (stdenv.hostPlatform.system == "x86_64-linux") {
  nixi686 = pkgsi686Linux.nixVersions.${self_attribute_name};
}
