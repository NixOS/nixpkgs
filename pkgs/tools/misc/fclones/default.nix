{ lib, stdenv, rustPlatform, fetchFromGitHub, pkg-config, udev }:

rustPlatform.buildRustPackage rec {
  pname = "fclones";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "pkolaczk";
    repo = pname;
    rev = "v${version}";
    sha256 = "1ni5amy903cy822yhw070bcrrixrw2m1vr66q1h32bc98pyv4w05";
  };

  cargoSha256 = "1gcb46k7bwdfsf6hyvmi6dna1nf6myzy63bhjfp0wy7c8g4m2mg8";

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
