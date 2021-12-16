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
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "ellie";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-I/ZDaOAiHdWOkmf+jIWWxZ3C25UHsl6MB7mCRLADFNs=";
  };

  cargoSha256 = "sha256-KMss6Mpn4LHnkhtJyRea+D7mKItBK4lqq9syFEmCiFo=";

  buildInputs = lib.optionals stdenv.isDarwin [ libiconv Security SystemConfiguration ];

  meta = with lib; {
    description = "Replacement for a shell history which records additional commands context with optional encrypted synchronization between machines";
    homepage = "https://github.com/ellie/atuin";
    license = licenses.mit;
    maintainers = [ maintainers.onsails ];
    broken = stdenv.isDarwin && stdenv.isAarch64;
  };
}
