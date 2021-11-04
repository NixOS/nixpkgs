{ callPackage, boost173, ... } @ args:

callPackage ./generic.nix (args // {
  version = "8.0.26-18";
  sha256 = "sha256-wluNdX++SP07BPei2rxWS6ATIxc+W4TZLY4TkXtg57c=";

  boost = boost173;

  extraPatches = [
    ./../../../servers/sql/mysql/abi-check.patch
  ];

  extraPostInstall = ''
    rm -r "$out"/docs
  '';
})
