args:
import ../generic.nix (
  args
  // {
    version = "15.4.26";
    hash = "sha256-LxMwCI/8otH32bRJvz9p1zWw4QzF/wrqeboZ6B3aw9o=";
    vendorHash = "sha256-VG9b1M3zdtRXY3eCFC7izejSSs4nTjtR9/wOc36PFnA=";
    yarnHash = "sha256-kmjY7KQfSzmlNS7ZK25YItZct/Tg7CWKfoRfubFBGlY=";
    cargoLock = {
      lockFile = ./Cargo.lock;
      outputHashes = {
        "boring-4.4.0" = "sha256-4wdl2kIA5oHQ0H6IddKQ+B5kRwrTeMbKe1+tAYZt2uw=";
        "ironrdp-async-0.1.0" = "sha256-nE5O/wRJ3vJqJG5zdYmpVkhx6JC6Yb92pR4EKSWSdkA=";
        "sspi-0.10.1" = "sha256-fkclC/plTh2d8zcmqthYmr5yXqbPTeFxI1VuaPX5vxk=";
      };
    };
  }
)
