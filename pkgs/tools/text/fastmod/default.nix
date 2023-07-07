{ lib, stdenv
, fetchFromGitHub
, rustPlatform
, libiconv
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "fastmod";
  version = "0.4.3";

  src = fetchFromGitHub {
    owner = "facebookincubator";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-j5+6ijJ04/Non7AUSN35OhfZ04MiPUDU4V1HLwZaM9k=";
  };

  cargoSha256 = "sha256-RNTnP3RKRZXo3+L54y/8nBunGbsxVY72sbl+ZrqfeMI=";

  buildInputs = lib.optionals stdenv.isDarwin [ libiconv Security ];

  meta = with lib; {
    description = "A utility that makes sweeping changes to large, shared code bases";
    homepage = "https://github.com/facebookincubator/fastmod";
    license = licenses.asl20;
    maintainers = with maintainers; [ jduan ];
  };
}
