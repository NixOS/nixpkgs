{ fetchFromGitHub, lib, rustPlatform, pkg-config, openssl, stdenv, Security, SystemConfiguration }:

rustPlatform.buildRustPackage rec {
  pname = "vrc-get";
  version = "1.5.2";

  src = fetchFromGitHub {
    owner = "anatawa12";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-DTiYyTZKYNprQSsAjHmpGdnS6dkXa3hSRGmIiLT/xr8=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [ Security SystemConfiguration ];

  # Make openssl-sys use pkg-config.
  OPENSSL_NO_VENDOR = 1;

  cargoHash = "sha256-4bhle98/zfw1uGNx+m1/4H9n63DnIezg/ZdV+zj0JNA=";

  meta = with lib; {
    description = "Command line client of VRChat Package Manager, the main feature of VRChat Creator Companion (VCC)";
    homepage = "https://github.com/anatawa12/vrc-get";
    license = licenses.mit;
    maintainers = with maintainers; [ bddvlpr ];
    mainProgram = "vrc-get";
  };
}
