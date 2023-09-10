{ fetchFromGitHub, lib, rustPlatform, pkg-config, openssl, stdenv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "vrc-get";
  version = "1.1.3";

  src = fetchFromGitHub {
    owner = "anatawa12";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-CJBwW2QsLNLyNubawBPD+Cy74JrrdSUHe7JBSdbMnjY=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [ Security ];

  # Make openssl-sys use pkg-config.
  OPENSSL_NO_VENDOR = 1;

  cargoHash = "sha256-PnNo+MmBo/Ke7pL6KwRKXz3gycJmbYefTRMWOvlCQaQ=";

  meta = with lib; {
    description = "Command line client of VRChat Package Manager, the main feature of VRChat Creator Companion (VCC)";
    homepage = "https://github.com/anatawa12/vrc-get";
    license = licenses.mit;
    maintainers = with maintainers; [ bddvlpr ];
  };
}
