{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "onetun";
  version = "0.3.7";

  src = fetchFromGitHub {
    owner = "aramperes";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-GVIRCMeuuhUA8lqQ1oI/Xcuf90QIlwhqYeU+HhbGWXQ=";
  };

  cargoHash = "sha256-TRfr4riMzR/MbsV2RiQNlPoPLhHK5EScNBCeyyamfgE=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    Security
  ];

  meta = with lib; {
    description = "Cross-platform, user-space WireGuard port-forwarder that requires no root-access or system network configurations";
    homepage = "https://github.com/aramperes/onetun";
    license = licenses.mit;
    maintainers = with maintainers; [ dit7ya ];
    mainProgram = "onetun";
  };
}
