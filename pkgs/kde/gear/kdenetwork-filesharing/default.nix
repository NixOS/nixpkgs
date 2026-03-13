{
  lib,
  mkKdeDerivation,
  replaceVars,
  qtdeclarative,
  samba,
  shadow,
}:
mkKdeDerivation {
  pname = "kdenetwork-filesharing";

  patches = [
    (replaceVars ./dependency-paths.patch {
      inherit samba;
      usermod = lib.getExe' shadow "usermod";
    })

    # Provide a more NixOS specific Samba hint
    ./samba-hint.patch
  ];

  extraBuildInputs = [
    qtdeclarative
  ];

  # We can't actually install samba via PackageKit, so let's not confuse users any more than we have to
  extraCmakeFlags = [ "-DSAMBA_INSTALL=OFF" ];

  # Hardcoded as QStrings, which are UTF-16 so Nix can't pick these up automatically
  postFixup = ''
    mkdir -p $out/nix-support
    echo "${samba} ${shadow}" > $out/nix-support/depends
  '';
}
