{ lib
, boost
, fetchFromGitHub
, libsodium
, nix
, pkg-config
, rustPlatform
, nix-update-script
, nixosTests
}:

rustPlatform.buildRustPackage rec {
  pname = "harmonia";
<<<<<<< HEAD
  version = "0.7.2";
=======
  version = "0.6.4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = pname;
    rev = "refs/tags/${pname}-v${version}";
<<<<<<< HEAD
    hash = "sha256-LzStxaqoez144LhqLjLP3yNgCj/HFqKSy+JcAW/FwM8=";
  };

  cargoHash = "sha256-4DXIMsT69PhxqZX1j2aJ/XDLjvX76WbzEN0yxrnP9v0=";
=======
    hash = "sha256-JH0tdUCadvovAJclpx7Fn1oD+POFpBFHdullRTcFaVQ=";
  };

  cargoHash = "sha256-Wa+7Vo5VWmx47Uf6YtlzHReoWY44SxdOnscSFu74OSM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = [
    pkg-config nix
  ];

  buildInputs = [
    boost
    libsodium
    nix
  ];

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
<<<<<<< HEAD
    mainProgram = "harmonia";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
