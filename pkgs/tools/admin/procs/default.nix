{ stdenv, fetchFromGitHub, rustPlatform, Security }:

rustPlatform.buildRustPackage rec {
  pname = "procs";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "dalance";
    repo = pname;
    rev = "v${version}";
    sha256 = "1bgsxvb9wxi4sz8jfamhdwaq9f2q2k7c3cdkk60k86mkmas8ibxz";
  };

  cargoSha256 = "0zf41clf3rqxmal894gqp9fn9bnas99wna13fc43fxdlvh92v4yh";

  buildInputs = stdenv.lib.optional stdenv.isDarwin Security;

  meta = with stdenv.lib; {
    description = "A modern replacement for ps written in Rust";
    homepage = "https://github.com/dalance/procs";
    license = licenses.mit;
    maintainers = with maintainers; [ dalance filalex77 ];
    platforms = with platforms; linux ++ darwin;
  };
}
