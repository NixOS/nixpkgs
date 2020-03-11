{ stdenv, fetchFromGitHub, rustPlatform, Security }:

rustPlatform.buildRustPackage rec {
  pname = "procs";
  version = "0.9.18";

  src = fetchFromGitHub {
    owner = "dalance";
    repo = pname;
    rev = "v${version}";
    sha256 = "0bqaj4a56h26sgiw2r453k6f252sy6lrb71ammr0ki3bqqqjhvdi";
  };

  cargoSha256 = "1rrwmi1wwjjql3chw996wki7mx0biaw9wc4v2xzv3vrxspvlvb5g";

  buildInputs = stdenv.lib.optional stdenv.isDarwin Security;

  meta = with stdenv.lib; {
    description = "A modern replacement for ps written in Rust";
    homepage = "https://github.com/dalance/procs";
    license = licenses.mit;
    maintainers = with maintainers;  [ dalance filalex77 ];
    platforms = with platforms; linux ++ darwin;
  };
}
