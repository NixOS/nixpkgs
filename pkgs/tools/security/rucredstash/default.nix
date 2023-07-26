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

  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ]
    ++ lib.optional stdenv.isDarwin Security;

  # Disable tests since it requires network access and relies on the
  # presence of certain AWS infrastructure
  doCheck = false;

  # update Cargo.lock to work with openssl 3
  postPatch = ''
    ln -sf ${./Cargo.lock} Cargo.lock
  '';

  meta = with lib; {
    description = "Rust port for credstash. Manages credentials securely in AWS cloud";
    homepage = "https://github.com/psibi/rucredstash";
    license = licenses.mit;
    maintainers = with maintainers; [ psibi ];
  };
}
