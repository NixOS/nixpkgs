{ stdenv, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "broot";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "Canop";
    repo = pname;
    rev = "v${version}";
    sha256 = "0i6ayp295xnppq92lc1fsfyrjkxrkvsva07yby45qa0l92nihqpy";
  };

  cargoSha256 = "1qdi1l0k0v00r9mfxgf09dzkvgxn07rcsl2yyyrhvcn731ak302y";

  meta = with stdenv.lib; {
    description = "An interactive tree view, a fuzzy search, a balanced BFS descent and customizable commands";
    homepage = "https://dystroy.org/broot/";
    maintainers = with maintainers; [ magnetophon ];
    license = with licenses; [ mit ];
    platforms = platforms.all;
  };
}
