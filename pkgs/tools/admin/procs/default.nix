{ stdenv, fetchFromGitHub, rustPlatform
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "procs";
  version = "0.8.9";

  src = fetchFromGitHub {
    owner = "dalance";
    repo = pname;
    rev = "v${version}";
    sha256 = "0gqbdk4gaxkpval52fsravjgvqz6c9zh1ahry57a2p6kszw96n13";
  };

  cargoSha256 = "1k0yl03rxbv009gb2jkc0f7mjq3pzc9bf8hppk2w9xicxpq6l55c";

  buildInputs = stdenv.lib.optional stdenv.isDarwin Security;

  meta = with stdenv.lib; {
    description = "A modern replacement for ps written in Rust";
    homepage = "https://github.com/dalance/procs";
    license = with licenses; [ mit ];
    maintainers = [ maintainers.dalance ];
    platforms = with platforms; linux ++ darwin;
  };
}
