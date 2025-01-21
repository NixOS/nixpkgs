{
  lib,
  mkKdeDerivation,
  substituteAll,
  samba,
  shadow,
  qtdeclarative,
}:
mkKdeDerivation {
  pname = "kdenetwork-filesharing";

  patches = [
    (substituteAll {
      src = ./dependency-paths.patch;
      inherit samba;
      usermod = lib.getExe' shadow "usermod";
    })

    # Provide a better looking and more NixOS specific Samba hint
    # Proposed upstream: https://invent.kde.org/network/kdenetwork-filesharing/-/merge_requests/56
    ./samba-hint.patch
  ];

  extraBuildInputs = [ qtdeclarative ];

  # We can't actually install samba via PackageKit, so let's not confuse users any more than we have to
  extraCmakeFlags = [ "-DSAMBA_INSTALL=OFF" ];

  # Hardcoded as QStrings, which are UTF-16 so Nix can't pick these up automatically
  postFixup = ''
    mkdir -p $out/nix-support
    echo "${samba} ${shadow}" > $out/nix-support/depends
  '';
}
