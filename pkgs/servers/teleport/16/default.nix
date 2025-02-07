args:
import ../generic.nix (
  args
  // {
    version = "16.4.14";
    hash = "sha256-9X4PLN5y1pJMNGL7o+NR/b3yUYch/VVEMmGmWbEO1CA=";
    vendorHash = "sha256-nJdtllxjem+EA77Sb1XKmrAaWh/8WrL3AuvVxgBRkxI=";
    pnpmHash = "sha256-+eOfGS9m3c9i7ccOS8q6KM0IrBIJZKlxx7h3qqxTJHE=";
    cargoLock = {
      lockFile = ./Cargo.lock;
      outputHashes = {
        "boring-4.7.0" = "sha256-ACzw4Bfo6OUrwvi3h21tvx5CpdQaWCEIDkslzjzy9o8=";
        "ironrdp-async-0.2.0" = "sha256-s0WdaEd3J2r/UmSVBktxtspIytlfw6eWUW3A4kOsTP0=";
      };
    };
  }
)
