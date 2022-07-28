{ lib, stdenv
, fetchFromGitHub
, fetchpatch
, rustPlatform
, Security
, libiconv
}:

rustPlatform.buildRustPackage rec {
  pname = "grex";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "pemistahl";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-iKrsiHGXaZ4OXkS28+6r0AhPZsb22fDVbDA2QjaVVTw=";
  };

  cargoSha256 = "sha256-J+kz4aj6CXm0QsMQfPwK+30EtQOtfpCwp821DLhpVCI=";

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
