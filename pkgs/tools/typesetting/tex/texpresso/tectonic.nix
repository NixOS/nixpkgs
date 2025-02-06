{ tectonic-unwrapped, fetchFromGitHub }:
tectonic-unwrapped.override (old: {
  rustPlatform = old.rustPlatform // {
    buildRustPackage =
      args:
      old.rustPlatform.buildRustPackage (
        args
        // {
          pname = "texpresso-tonic";
          src = fetchFromGitHub {
            owner = "let-def";
            repo = "tectonic";
            rev = "b38cb3b2529bba947d520ac29fbb7873409bd270";
            hash = "sha256-ap7fEPHsASAphIQkjcvk1CC7egTdxaUh7IpSS5os4W8=";
            fetchSubmodules = true;
          };
          useFetchCargoVendor = true;
          cargoHash = "sha256-mqhbIv5r/5EDRDfP2BymXv9se2NCKxzRGqNqwqbD9A0=";
          # binary has a different name, bundled tests won't work
          doCheck = false;
          meta.mainProgram = "texpresso-tonic";
        }
      );
  };
})
