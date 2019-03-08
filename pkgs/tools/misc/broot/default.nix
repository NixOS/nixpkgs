{ stdenv, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  name = "broot-${version}";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "Canop";
    repo = "broot";
    rev = "v${version}";
    sha256 = "1rn6km5dz5bgphsswll3mwyzfkfq64j4sdwcyzkk6mmcdpzdairz";
  };

  cargoSha256 = "0722nzip3rl47rjrzyb2y3xbsy9ww1ldjv84qbzyy3flcyh2adjm";

  meta = with stdenv.lib; {
    description = "An interactive tree view, a fuzzy search, a balanced BFS descent and customizable commands";
    homepage = "https://github.com/Canop/broot";
    maintainers = with maintainers; [ magnetophon ];
    license = with licenses; [ mit ];
    platforms = platforms.all;
  };
}
