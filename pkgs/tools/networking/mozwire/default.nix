{ rustPlatform, lib, stdenv, fetchFromGitHub, Security }:

rustPlatform.buildRustPackage rec {
  pname = "MozWire";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "NilsIrl";
    repo = pname;
    rev = "v${version}";
    sha256 = "01bj3c34x9ywxygsz4rdyw5gc9cz8x6zzl5fd7db8qy8bx2lhlr9";
  };

  buildInputs = lib.optionals stdenv.isDarwin [ Security ];

  cargoSha256 = "1gplibywiqiqk5mmglzm04451phbd0hrdh9smlhvbnwm9bj5q9qm";

  meta = with lib; {
    description = "MozillaVPN configuration manager giving Linux, macOS users (among others), access to MozillaVPN";
    homepage = "https://github.com/NilsIrl/MozWire";
    license = licenses.gpl3;
    maintainers = with maintainers; [ siraben nilsirl ];
  };
}
