{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, libiconv
, Security
, SystemConfiguration
}:

rustPlatform.buildRustPackage rec {
  pname = "atuin";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "ellie";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-jjGP8YeHnEr0f9RONwA6wZT872C0jXTvSRdt9zAu6KE=";
  };

  cargoSha256 = "0vy6q3hjp374lyg00zxim8aplh83iq3f4rrmpz5vnpwbag1fdql3";

  buildInputs = lib.optionals stdenv.isDarwin [ libiconv Security SystemConfiguration ];

  meta = with lib; {
    description = "Replacement for a shell history which records additional commands context with optional encrypted synchronization between machines";
    homepage = "https://github.com/ellie/atuin";
    license = licenses.mit;
    maintainers = [ maintainers.onsails ];
    broken = stdenv.isDarwin && stdenv.isAarch64;
  };
}
