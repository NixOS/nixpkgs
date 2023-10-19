{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "onetun";
  version = "0.3.5";

  src = fetchFromGitHub {
    owner = "aramperes";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-svf30eFldfbhi8L44linHccGApYFuEWZOjzyqM+tjw4=";
  };

  cargoHash = "sha256-KcixaVNZEpGeMg/sh3dua3D7vqzlBvf+Zh3MKk6LJac=";

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
