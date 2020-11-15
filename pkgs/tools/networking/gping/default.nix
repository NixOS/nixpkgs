{ lib
, fetchFromGitHub
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "gping";
  version = "0.1.6";

  src = fetchFromGitHub {
    owner  = "orf";
    repo = "gping";
    rev = "v${version}";
    sha256 = "Qqtx+a5H/rAQu2A3oUXPiw7qJbH3mXOyT86BIXPmnOk=";
  };

  cargoSha256 = "E9WmfpJU/aPxRF/h6tv5wXZQ5JGDXEN/tYlKxQrNTrc=";

  meta = with lib; {
    description = "Ping, but with a graph";
    homepage = "https://github.com/orf/gping";
    license = licenses.mit;
    maintainers = with maintainers; [ andrew-d ];
  };
}
