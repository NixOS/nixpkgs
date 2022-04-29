{ lib, stdenv
, fetchFromGitHub
, fetchpatch
, rustPlatform
, Security
, libiconv
}:

rustPlatform.buildRustPackage rec {
  pname = "grex";
  version = "1.3.0";

  cargoSha256 = "sha256-zNwTk4RcTv2dGbKWelOPSvasBmj7tnjLhQ0DZhZ9hxk=";

  src = fetchFromGitHub {
    owner = "pemistahl";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-NMz35jgd7XPemVdA8nol2H6cgWD3yEPh0FEMPw8kgKQ=";
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
