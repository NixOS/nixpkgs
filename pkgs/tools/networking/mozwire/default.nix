{ rustPlatform, stdenv, fetchFromGitHub, Security }:

rustPlatform.buildRustPackage rec {
  pname = "MozWire";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "NilsIrl";
    repo = pname;
    rev = "v${version}";
    sha256 = "07icgswmfvrvlm3mkm78pbbk6m2hb73j7ffj7r77whzb11v027v1";
  };

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ Security ];
  
  cargoSha256 = "10lhz7bdlfqj7wgsqnsxdfskms33pvj176fhf4kwci7nb8vgai4b";

  meta = with stdenv.lib; {
    description = "MozillaVPN configuration manager giving Linux, macOS users (among others), access to MozillaVPN";
    homepage = "https://github.com/NilsIrl/MozWire";
    license = licenses.gpl3;
    maintainers = with maintainers; [ siraben nilsirl ];
  };
}
