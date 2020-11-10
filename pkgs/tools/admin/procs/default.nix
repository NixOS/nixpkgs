{ stdenv, fetchFromGitHub, rustPlatform, Security }:

rustPlatform.buildRustPackage rec {
  pname = "procs";
  version = "0.10.5";

  src = fetchFromGitHub {
    owner = "dalance";
    repo = pname;
    rev = "v${version}";
    sha256 = "0w6a8pfk5s30yi5038kdqh4dncx2pskm7a23z66c4xj3842ci79c";
  };

  cargoSha256 = "07fwznx2czk1ibb77xcfhma9dpqps0m7rsmbb90gah6f32gah617";

  buildInputs = stdenv.lib.optional stdenv.isDarwin Security;

  meta = with stdenv.lib; {
    description = "A modern replacement for ps written in Rust";
    homepage = "https://github.com/dalance/procs";
    license = licenses.mit;
    maintainers = with maintainers; [ dalance filalex77 ];
    platforms = with platforms; linux ++ darwin;
  };
}
