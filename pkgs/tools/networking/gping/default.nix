{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, libiconv
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "gping";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "orf";
    repo = "gping";
    rev = "gping-v${version}";
    sha256 = "sha256-hAUmRUMhP3rD1k6UhIN94/Kt+OjaytUTM3XIcrvasco=";
  };

  cargoSha256 = "sha256-SqQsKTS3psF/xfwyBRQB9c3/KIZU1fpyqVy9fh4Rqkk=";

  buildInputs = lib.optionals stdenv.isDarwin [ libiconv Security ];

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/gping --version | grep "${version}"
  '';

  meta = with lib; {
    description = "Ping, but with a graph";
    homepage = "https://github.com/orf/gping";
    license = licenses.mit;
    maintainers = with maintainers; [ andrew-d ];
  };
}
