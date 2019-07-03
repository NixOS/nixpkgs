{ stdenv, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "broot";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "Canop";
    repo = pname;
    rev = "v${version}";
    sha256 = "0xgjpdy12b77hgf0vfgs2ayxaajjv8vs0v8fn4rnrgn3hz8ldhyc";
  };

  cargoSha256 = "1hsrp9xbi6bj3461y58hmzfwakx4vakpzkjvi6174gy8xq7cdvg1";

  meta = with stdenv.lib; {
    description = "An interactive tree view, a fuzzy search, a balanced BFS descent and customizable commands";
    homepage = "https://dystroy.org/broot/";
    maintainers = with maintainers; [ magnetophon ];
    license = with licenses; [ mit ];
    platforms = platforms.all;
  };
}
