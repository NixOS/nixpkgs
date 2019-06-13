{ stdenv, fetchFromGitHub, rustPlatform
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "procs";
  version = "0.8.5";

  src = fetchFromGitHub {
    owner = "dalance";
    repo = pname;
    rev = "v${version}";
    sha256 = "0ihww2sm9hnh748723lr1cxw9zyi9nfxbbiij5a465mypa2p7w0v";
  };

  cargoSha256 = "1aq2nhspb9kp9mzj5550xph09qvd0ahlw246hcx2mqkr4frh64x0";

  buildInputs = stdenv.lib.optional stdenv.isDarwin Security;

  meta = with stdenv.lib; {
    description = "A modern replacement for ps written in Rust";
    homepage = "https://github.com/dalance/procs";
    license = with licenses; [ mit ];
    maintainers = [ maintainers.dalance ];
    platforms = with platforms; linux ++ darwin;
  };
}
