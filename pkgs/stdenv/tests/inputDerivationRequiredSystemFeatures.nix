{ lib, stdenv }:
let
  impossibleToBuildPackage = stdenv.mkDerivation {
    name = "impossible-to-build-package";
    # According to the Nix manual, the "apple-virt" system feature is
    # Darwin-only and the "kvm" system feature is Linux-only [1].
    #
    # [1]: <https://nix.dev/manual/nix/2.32/command-ref/conf-file.html#conf-system-features>
    requiredSystemFeatures = if stdenv.buildPlatform.isLinux then "apple-virt" else "kvm";

    buildCommand = ''
      echo ERROR: It’s supposed to be impossible to start building this package. >&2
      exit 1
    '';
  };
in
stdenv.mkDerivation {
  name = "stdenv-test-inputDerivationRequiredSystemFeatures";

  impossibleToBuildPackageInputDerivation = impossibleToBuildPackage.inputDerivation;
  buildCommand = ''
    ln --symbolic "$impossibleToBuildPackageInputDerivation" "$out"
  '';

  meta = {
    longDescription = ''
      In previous versions of Nixpkgs,
      `<originalDerivation>.inputDerivation.requiredSystemFeatures` would
      always be the same as `<originalDerivation>.requiredSystemFeatures`. This
      meant that if a builder wasn’t able to build `<originalDerivation>` due
      to a lack of system features, then that builder would also not be able to
      build `<originalDerivation>.inputDerivation`.

      That was an aribtrary (and probably accidental) limitation. Building
      input derivations never requires any system features. This test checks to
      make sure that that limitation no longer exists.
    '';
    maintainers = [ lib.maintainers.jayman2000 ];
  };
}
