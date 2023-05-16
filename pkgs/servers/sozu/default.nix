<<<<<<< HEAD
{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, darwin
, protobuf
, nix-update-script
, testers
, sozu
}:

rustPlatform.buildRustPackage rec {
  pname = "sozu";
  version = "0.15.3";
=======
{ lib, stdenv, rustPlatform, fetchFromGitHub, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "sozu";
  version = "0.13.6";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "sozu-proxy";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    hash = "sha256-hZQ5pRzQy+BMGnxCl0Mw3hqCHZJcZ30vhqt6gWyLXWU=";
  };

  cargoHash = "sha256-KFOsKyZZOWvkkTuLqVeLmHlk6HscEJi0sI2hJS6UnOU=";

  nativeBuildInputs = [ protobuf ];
=======
    sha256 = "sha256-C2wIkneOh6t8gjoHRYMRorAKEVvM3R+NRZbG9hhCE5A=";
  };

  cargoSha256 = "sha256-Ej2/X1aQ8uRdZKpVRT4+AzhDWMv/sT8GrCitUmkrHmI=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  buildInputs =
    lib.optional stdenv.isDarwin darwin.apple_sdk.frameworks.Security;

<<<<<<< HEAD
  doCheck = false;

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion {
      package = sozu;
      command = "sozu --version";
      version = "${version}";
    };
  };

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description =
      "Open Source HTTP Reverse Proxy built in Rust for Immutable Infrastructures";
    homepage = "https://www.sozu.io";
<<<<<<< HEAD
    changelog = "https://github.com/sozu-proxy/sozu/releases/tag/${version}";
    license = licenses.agpl3;
    maintainers = with maintainers; [ Br1ght0ne gaelreyrol ];
    # error[E0432]: unresolved import `std::arch::x86_64`
    broken = !stdenv.isx86_64;
=======
    license = licenses.agpl3;
    maintainers = with maintainers; [ Br1ght0ne ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
