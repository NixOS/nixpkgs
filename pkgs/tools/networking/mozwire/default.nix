{ rustPlatform, stdenv, fetchFromGitHub, Security }:

rustPlatform.buildRustPackage rec {
  pname = "MozWire";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "NilsIrl";
    repo = pname;
    rev = "v${version}";
    sha256 = "0r3x8y1qxxkkac9lqgd0s339zbrm9zmir1f6qs0r5f0bw3ngzqc4";
  };

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ Security ];

  cargoSha256 = "0hyps2wi4wmpllfams3p59jpccwa0ylgzxq7qdn6g6zvf0cajpc0";

  meta = with stdenv.lib; {
    description = "MozillaVPN configuration manager giving Linux, macOS users (among others), access to MozillaVPN";
    homepage = "https://github.com/NilsIrl/MozWire";
    license = licenses.gpl3;
    maintainers = with maintainers; [ siraben nilsirl ];
  };
}
