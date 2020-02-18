{ stdenv, fetchFromGitHub, rustPlatform, Security }:

rustPlatform.buildRustPackage rec {
  pname = "procs";
  version = "0.9.11";

  src = fetchFromGitHub {
    owner = "dalance";
    repo = pname;
    rev = "v${version}";
    sha256 = "0nz06q1rdrqgprclgr30la2vp4bx0qgibh22vdlqpd4rzi3x0h2r";
  };

  cargoSha256 = "0hmz19ndfcg7bsrjk89ck9x99ibsvghqwmvgcd89vxmjr5h13rsg";

  buildInputs = stdenv.lib.optional stdenv.isDarwin Security;

  meta = with stdenv.lib; {
    description = "A modern replacement for ps written in Rust";
    homepage = "https://github.com/dalance/procs";
    license = licenses.mit;
    maintainers = with maintainers;  [ dalance filalex77 ];
    platforms = with platforms; linux ++ darwin;
  };
}
