{ lib, stdenv, fetchFromGitHub, rustPlatform
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "amber";
  version = "0.5.8";

  src = fetchFromGitHub {
    owner = "dalance";
    repo = pname;
    rev = "v${version}";
    sha256 = "0j9h9zzg6n4mhq2bqj71k5db595ilbgd9dn6ygmzsm74619q4454";
  };

  cargoSha256 = "0h47xqqq8f8m28rl1s6r305cf3dvk94aa86j6m0rk535i2jqfvhp";

  buildInputs = lib.optional stdenv.isDarwin Security;

  meta = with lib; {
    description = "A code search-and-replace tool";
    homepage = "https://github.com/dalance/amber";
    license = with licenses; [ mit ];
    maintainers = [ maintainers.bdesham ];
  };
}
