{ lib, stdenv, rustPlatform, fetchFromGitHub, pkg-config, openssl, curl, sqlite
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "nix-index";
<<<<<<< HEAD
  version = "0.1.7";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "nix-index";
    rev = "v${version}";
    hash = "sha256-WPWd2aMuP4L17UDFz7SI6lqyrCzrPV8c88vGyO6r6jk=";
  };

  cargoHash = "sha256-zZhQ3pOid7BCGzcyCrl6sDm0q6IEVKF7K+d6nVs9flk=";
=======
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "bennofs";
    repo = "nix-index";
    rev = "v${version}";
    sha256 = "sha256-/btQP7I4zpIA0MWEQJVYnR1XhyudPnYD5Qx4vrW+Uq8=";
  };

  cargoSha256 = "sha256-CzLBOLtzIYqdWjTDKHVnc1YXXyj1HqvXzoFYHS0qxog=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl curl sqlite ]
    ++ lib.optional stdenv.isDarwin Security;

  postInstall = ''
<<<<<<< HEAD
    substituteInPlace command-not-found.sh \
      --subst-var out
    install -Dm555 command-not-found.sh -t $out/etc/profile.d
=======
    mkdir -p $out/etc/profile.d
    cp ./command-not-found.sh $out/etc/profile.d/command-not-found.sh
    substituteInPlace $out/etc/profile.d/command-not-found.sh \
      --replace "@out@" "$out"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  '';

  meta = with lib; {
    description = "A files database for nixpkgs";
<<<<<<< HEAD
    homepage = "https://github.com/nix-community/nix-index";
    changelog = "https://github.com/nix-community/nix-index/blob/${src.rev}/CHANGELOG.md";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ bennofs figsoda ncfavier ];
=======
    homepage = "https://github.com/bennofs/nix-index";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ bennofs ncfavier ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
