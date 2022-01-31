{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, fetchpatch
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

  patches = [
    (fetchpatch {
      url = "https://github.com/orf/gping/commit/b843beb9617e4b7b98d4f6d3942067cad59c9d60.patch";
      sha256 = "sha256-9DIeeweCuGqymvUj4EBct82XVevkFSbHWaV76ExjGbs=";
    })
  ];

  buildInputs = lib.optional stdenv.isDarwin libiconv;

  meta = with lib; {
    description = "Ping, but with a graph";
    homepage = "https://github.com/orf/gping";
    license = licenses.mit;
    maintainers = with maintainers; [ andrew-d ];
  };
}
