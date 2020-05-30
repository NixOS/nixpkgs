{ stdenv, fetchFromGitHub, rustPlatform, Security }:

rustPlatform.buildRustPackage rec {
  pname = "procs";
  version = "0.10.3";

  src = fetchFromGitHub {
    owner = "dalance";
    repo = pname;
    rev = "v${version}";
    sha256 = "0lg4v32jx0fxcjz6cj6cxxlg7rhj75k4p75izpkk4l11xpxqhgjm";
  };

  cargoSha256 = "05qqy6l28ihn7hykkkh1x7z3q58cdrwv76fc22xjcg20985ac2nx";

  buildInputs = stdenv.lib.optional stdenv.isDarwin Security;

  meta = with stdenv.lib; {
    description = "A modern replacement for ps written in Rust";
    homepage = "https://github.com/dalance/procs";
    license = licenses.mit;
    maintainers = with maintainers; [ dalance filalex77 ];
    platforms = with platforms; linux ++ darwin;
  };
}
