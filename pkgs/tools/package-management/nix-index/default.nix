{ lib, stdenv, rustPlatform, fetchFromGitHub, pkg-config, openssl, curl
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "nix-index";
  version = "unstable-2022-03-07";

  src = fetchFromGitHub {
    owner = "bennofs";
    repo = "nix-index";
    rev = "f09548f66790d2d7d53f07ad2af62993d7cabb08";
    sha256 = "sha256-xIJCzEHQJ2kHRbT4Ejrb5R5e/VqjKrklV7XneZIiyUg=";
  };

  cargoSha256 = "sha256-2Yhnacsx8EWsfZfcfKhV687cblyFDmsfdqGZoK6Lulo=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl curl ]
    ++ lib.optional stdenv.isDarwin Security;

  postInstall = ''
    mkdir -p $out/etc/profile.d
    cp ./command-not-found.sh $out/etc/profile.d/command-not-found.sh
    substituteInPlace $out/etc/profile.d/command-not-found.sh \
      --replace "@out@" "$out"
  '';

  meta = with lib; {
    description = "A files database for nixpkgs";
    homepage = "https://github.com/bennofs/nix-index";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ bennofs ncfavier ];
  };
}
