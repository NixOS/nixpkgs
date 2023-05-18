{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "onetun";
  version = "0.3.4";

  src = fetchFromGitHub {
    owner = "aramperes";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-gVw1aVbYjDPYTtMYIXq3k+LN0gUBAbQm275sxzwoYw8=";
  };

  cargoSha256 = "sha256-/sOjd0JKk3MNNXYpTEXteFYtqDWYfyVItZrkX4uzjtc=";

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
