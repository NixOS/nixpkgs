args:
import ../generic.nix (
  args
  // {
    version = "16.4.6";
    hash = "sha256-TdOCFs6YeqINM8aPryrjYPaXEjc/gIqu7kzVYDnMsjg=";
    vendorHash = "sha256-iyYfht0aB9Vv2hsaqrieFHXbDhlotKQYfLn4JFqpve8=";
    pnpmHash = "sha256-NF45Wp4itYud01VzxC8bRHZ3xZ1T1du1QmZTDMS5nOk=";
    cargoLock = {
      lockFile = ./Cargo.lock;
      outputHashes = {
        "boring-4.7.0" = "sha256-ACzw4Bfo6OUrwvi3h21tvx5CpdQaWCEIDkslzjzy9o8=";
        "ironrdp-async-0.1.0" = "sha256-DOwDHavDaEda+JK9M6kbvseoXe2LxJg3MLTY/Nu+PN0=";
      };
    };
  }
)
