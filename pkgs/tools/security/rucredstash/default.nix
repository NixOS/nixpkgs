{ lib, rustPlatform, fetchFromGitHub, pkg-config, openssl, stdenv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "rucredstash";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "psibi";
    repo = "rucredstash";
    rev = "v${version}";
    sha256 = "1jwsj2y890nxpgmlfbr9hms2raspp5h89ykzsh014mf7lb3yxzwg";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ]
    ++ lib.optional stdenv.isDarwin Security;

  # Disable tests since it requires network access and relies on the
  # presence of certain AWS infrastructure
  doCheck = false;

  cargoSha256 = "0qnfrwpdvjksc97iiwn1r6fyqaqn0q3ckbdzswf9flvwshqzb6ih";

  meta = with lib; {
    description = "Rust port for credstash. Manages credentials securely in AWS cloud";
    homepage = "https://github.com/psibi/rucredstash";
    license = licenses.mit;
    maintainers = with maintainers; [ psibi ];
  };
}
