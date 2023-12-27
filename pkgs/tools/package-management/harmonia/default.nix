{ lib
, boost
, fetchFromGitHub
, libsodium
, nixVersions
, pkg-config
, rustPlatform
, stdenv
, nix-update-script
, nixosTests
}:

rustPlatform.buildRustPackage rec {
  pname = "harmonia";
  version = "0.7.4";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = pname;
    rev = "refs/tags/${pname}-v${version}";
    hash = "sha256-72JMrXmxw/FuGjqXXxMIGiAbUUOqXEERdQwch+s3iwU=";
  };

  cargoHash = "sha256-Q5Y5v7mmJpfZFGRgurTcRBRtbApFRrwqOBHdZTJbyzc=";

  nativeBuildInputs = [
    pkg-config nixVersions.nix_2_19
  ];

  buildInputs = [
    boost
    libsodium
    nixVersions.nix_2_19
  ];

  # Workaround for https://github.com/NixOS/nixpkgs/issues/166205
  env = lib.optionalAttrs stdenv.cc.isClang {
    NIX_LDFLAGS = "-l${stdenv.cc.libcxx.cxxabi.libName}";
  };

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [ "--version-regex" "harmonia-v(.*)" ];
    };
    tests = { inherit (nixosTests) harmonia; };
  };

  meta = with lib; {
    description = "Nix binary cache";
    homepage = "https://github.com/nix-community/harmonia";
    license = licenses.mit;
    maintainers = with maintainers; [ mic92 ];
    mainProgram = "harmonia";
  };
}
