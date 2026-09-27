{ callPackage, ccextractor }:

callPackage ./common.nix { } {
  pname = "tdarr-server";
  component = "server";

  hashes = {
    linux_x64 = "sha256-dAXcBPJ8wOxx4gg50mN6nEgUcDqEOn17eByX2FvphrQ=";
    linux_arm64 = "sha256-MDDhkSmMTiOEezKpInR86TItkVnX20IKblUf2JUKnKg=";
    darwin_x64 = "sha256-faCNm8eeJzQq3Doyac/vtmx80dOTaWVMIErgNwz77xk=";
    darwin_arm64 = "sha256-NNEvCFZvPJFy6Elh7voeSe847bGVJpnOt/ac5nLEy7Y=";
  };

  includeInPath = [ ccextractor ];
  installIcons = true;
}
