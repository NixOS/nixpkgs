{ lib, stdenv, rustPlatform, fetchFromGitHub, pkg-config, openssl, curl, sqlite
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "nix-index";
  version = "0.1.7";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "nix-index";
    rev = "v${version}";
    hash = "sha256-WPWd2aMuP4L17UDFz7SI6lqyrCzrPV8c88vGyO6r6jk=";
  };

  cargoHash = "sha256-zZhQ3pOid7BCGzcyCrl6sDm0q6IEVKF7K+d6nVs9flk=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl curl sqlite ]
    ++ lib.optional stdenv.isDarwin Security;

  postInstall = ''
    substituteInPlace command-not-found.sh \
      --subst-var out
    install -Dm555 command-not-found.sh -t $out/etc/profile.d
  '';

  meta = with lib; {
    description = "A files database for nixpkgs";
    homepage = "https://github.com/nix-community/nix-index";
    changelog = "https://github.com/nix-community/nix-index/blob/${src.rev}/CHANGELOG.md";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ bennofs figsoda ncfavier ];
  };
}
