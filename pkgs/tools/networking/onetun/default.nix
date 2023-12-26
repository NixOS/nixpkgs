{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "onetun";
  version = "0.3.6";

  src = fetchFromGitHub {
    owner = "aramperes";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-NH3K/EGFtBcTAxGntneV86zd8eWSV4fFxvr76xtE/mw=";
  };

  cargoHash = "sha256-ZpgcFzQLiOWyhjSI+WcLa0UFUw8zQWfqJkrVVpIexgM=";

  buildInputs = lib.optionals stdenv.isDarwin [
    Security
  ];

  meta = with lib; {
    description = "A cross-platform, user-space WireGuard port-forwarder that requires no root-access or system network configurations";
    homepage = "https://github.com/aramperes/onetun";
    license = licenses.mit;
    maintainers = with maintainers; [ dit7ya ];
  };
}
