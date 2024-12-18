{ lib
, fetchFromGitHub
, rustPlatform
, stdenv
, pkg-config
, dbus
, openssl
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "git-ps-rs";
  version = "7.2.0";

  src = fetchFromGitHub {
    owner = "uptech";
    repo = "git-ps-rs";
    rev = version;
    hash = "sha256-OkQLuTZ4CFxA8Ezpo7ChVDR3BzLzlF/EOkZjTIbjJl4=";
  };

  cargoHash = "sha256-9SmUGSHPhByBkSyuyNSBCsYsWxF7e13i00Jbf4COOj4=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl dbus ] ++ lib.optionals stdenv.isDarwin [ Security ];

  meta = with lib; {
    description = "Tool for working with a stack of patches";
    mainProgram = "gps";
    homepage = "https://git-ps.sh/";
    license = licenses.mit;
    maintainers = with maintainers; [ alizter ];
  };
}
