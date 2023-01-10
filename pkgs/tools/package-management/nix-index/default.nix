{ lib, stdenv, rustPlatform, fetchFromGitHub, pkg-config, openssl, curl, sqlite
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "nix-index";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "bennofs";
    repo = "nix-index";
    rev = "v${version}";
    sha256 = "sha256-UbM4041AiYUOcj8e5dJ5HmD26Db3szs6dABVCwseliU=";
  };

  cargoSha256 = "sha256-TMfnjtUo7Kxx/kWnc0scC8qU6vi+E+TL0hE73NNIyjk=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl curl sqlite ]
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
