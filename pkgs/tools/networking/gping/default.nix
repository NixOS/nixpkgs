{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, libiconv
}:

rustPlatform.buildRustPackage rec {
  pname = "gping";
  version = "1.2.6";

  src = fetchFromGitHub {
    owner = "orf";
    repo = "gping";
    rev = "gping-v${version}";
    sha256 = "sha256-Sxmwuf+iTBTlpfMFCEUp6JyEaoHgmLIKB/gws2KY/xc=";
  };

  cargoSha256 = "sha256-xEASs6r5zxYJXS+at6aX5n0whGp5qwuNwq6Jh0GM+/4=";

  buildInputs = lib.optional stdenv.isDarwin libiconv;

  meta = with lib; {
    description = "Ping, but with a graph";
    homepage = "https://github.com/orf/gping";
    license = licenses.mit;
    maintainers = with maintainers; [ andrew-d ];
  };
}
