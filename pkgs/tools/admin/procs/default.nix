{ stdenv, fetchFromGitHub, rustPlatform, Security }:

rustPlatform.buildRustPackage rec {
  pname = "procs";
  version = "0.9.20";

  src = fetchFromGitHub {
    owner = "dalance";
    repo = pname;
    rev = "v${version}";
    sha256 = "00qqn8nwv791bs88n302hy67dpas5hcacnkakn7law567klnzxfz";
  };

  cargoSha256 = "09ib1nlqhzq3mc5wc16mgqbyr652asrwdpbwaax54fm1gd334prl";

  buildInputs = stdenv.lib.optional stdenv.isDarwin Security;

  meta = with stdenv.lib; {
    description = "A modern replacement for ps written in Rust";
    homepage = "https://github.com/dalance/procs";
    license = licenses.mit;
    maintainers = with maintainers;  [ dalance filalex77 ];
    platforms = with platforms; linux ++ darwin;
  };
}
