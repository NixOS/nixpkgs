{ lib, stdenv
, fetchFromGitHub
, fetchpatch
, rustPlatform
, Security
, libiconv
}:

rustPlatform.buildRustPackage rec {
  pname = "grex";
  version = "1.1.0";

  cargoSha256 = "0argn8y8f498yj1qgr15mnz35dp2hpnwnsz3hz14c5cf35m6l232";

  src = fetchFromGitHub {
    owner = "pemistahl";
    repo = pname;
    rev = "v${version}";
    sha256 = "1viph7ki6f2akc5mpbgycacndmxnv088ybfji2bfdbi5jnpyavvs";
  };

  buildInputs = lib.optionals stdenv.isDarwin [ Security ];

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/grex --help > /dev/null
  '';

  meta = with lib; {
    description = "A command-line tool for generating regular expressions from user-provided test cases";
    homepage = "https://github.com/pemistahl/grex";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
