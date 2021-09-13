{ lib, stdenv, rustPlatform, fetchFromGitHub, pkg-config, udev }:

rustPlatform.buildRustPackage rec {
  pname = "fclones";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "pkolaczk";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-8NUneKJpnBjC4OcAABEpI9p+saBqAk+l43FS8/tIYjc=";
  };

  cargoSha256 = "sha256-5qX45FJFaiE1vTXjllM9U1w57MX18GgKEFOEBMc64Jk=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ udev ];

  # tests in dedupe.rs fail due to
  # "creation time is not available for the filesystem"
  doCheck = false;

  meta = with lib; {
    description = "Efficient Duplicate File Finder and Remover";
    homepage = "https://github.com/pkolaczk/fclones";
    license = licenses.mit;
    maintainers = with maintainers; [ cyounkins ];
  };
}
