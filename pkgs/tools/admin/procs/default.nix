{ stdenv, fetchFromGitHub, rustPlatform
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "procs";
  version = "0.8.13";

  src = fetchFromGitHub {
    owner = "dalance";
    repo = pname;
    rev = "v${version}";
    sha256 = "0yy41v2crds9500fa4r0kqiddciqkilr2h13nrjqy44ckvw2mi5y";
  };

  cargoSha256 = "1gnl97h0l9k8xnrwl6807qlbx13vd45kmla02mk9p1h52sr0din5";

  buildInputs = stdenv.lib.optional stdenv.isDarwin Security;

  meta = with stdenv.lib; {
    description = "A modern replacement for ps written in Rust";
    homepage = "https://github.com/dalance/procs";
    license = with licenses; [ mit ];
    maintainers = [ maintainers.dalance ];
    platforms = with platforms; linux ++ darwin;
  };
}
