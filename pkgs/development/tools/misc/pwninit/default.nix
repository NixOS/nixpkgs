{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, openssl
, pkg-config
, xz
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "pwninit";
  version = "3.2.0";

  src = fetchFromGitHub {
    owner = "io12";
    repo = "pwninit";
    rev = version;
    sha256 = "sha256-XKDYJH2SG3TkwL+FN6rXDap8la07icR0GPFiYcnOHeI=";
  };

  buildInputs = [ openssl xz ] ++ lib.optionals stdenv.isDarwin [ Security ];
  nativeBuildInputs = [ pkg-config ];
  doCheck = false; # there are no tests to run

  cargoSha256 = "sha256-2HCHiU309hbdwohUKVT3TEfGvOfxQWtEGj7FIS8OS7s=";

  meta = {
    description = "Automate starting binary exploit challenges";
    homepage = "https://github.com/io12/pwninit";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.scoder12 ];
    platforms = lib.platforms.all;
  };
}
