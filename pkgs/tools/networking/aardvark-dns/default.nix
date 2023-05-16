{ lib
, rustPlatform
, fetchFromGitHub
, nixosTests
}:

rustPlatform.buildRustPackage rec {
  pname = "aardvark-dns";
<<<<<<< HEAD
  version = "1.7.0";
=======
  version = "1.6.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "containers";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-bScL8hFV/Kot7P9nJRMDDhB8pllPUsejtJpbjmQ8skI=";
  };

  cargoHash = "sha256-rrn+ZTAsFs7UTP4xQL3Cy8G6RG7vwT0wMKnXHHIkB90=";

  checkFlags = [
    # https://github.com/containers/aardvark-dns/issues/379
    "--skip=test::test::tests::test_backend_network_scoped_custom_dns_server"
  ];
=======
    hash = "sha256-l240kejJjv3rVb4S9ngXo88kmByuS/Co3AB/SSv+iIA=";
  };

  cargoHash = "sha256-d3u/He8+Ei+tX37EgYTGW5gjcalawlTdPekV9iLK7XI=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  passthru.tests = { inherit (nixosTests) podman; };

  meta = with lib; {
    changelog = "https://github.com/containers/aardvark-dns/releases/tag/${src.rev}";
    description = "Authoritative dns server for A/AAAA container records";
    homepage = "https://github.com/containers/aardvark-dns";
    license = licenses.asl20;
    maintainers = with maintainers; [ ] ++ teams.podman.members;
    platforms = platforms.linux;
  };
}
