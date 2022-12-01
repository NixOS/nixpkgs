{ stdenv
, lib
, rustPlatform
, fetchFromGitHub
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "bpb";
  version = "unstable-2018-07-27";

  src = fetchFromGitHub {
    owner = "withoutboats";
    repo = "bpb";
    rev = "b1ef5ca1d2dea0e2ec0b1616f087f110ea17adfa";
    sha256 = "sVfM8tlAsF4uKLxl3g/nSYgOx+znHIdPalSIiCd18o4=";
  };

  cargoSha256 = "7cARRJWRxF1kMySX6KcB6nrVf8k1p/nr3OyAwNLmztc=";

  # a nightly compiler is required unless we use this cheat code.
  RUSTC_BOOTSTRAP = 1;

  buildInputs = lib.optional stdenv.isDarwin Security;

  meta = with lib; {
    description = "Tool to automatically sign git commits, replacing gpg for that purpose";
    homepage = "https://github.com/withoutboats/bpb";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
