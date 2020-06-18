{ stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "the-way";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "out-of-cheese-error";
    repo = pname;
    rev = "v${version}";
    sha256 = "02aa4iwwi89r6sj1q5sj74n2cy1rj94yfh39cp97zlx4lam9pj6b";
  };

  cargoSha256 = "1360ls1i5v0x4ksmrzhvh5mvpl1fx8zr8w3sp9rs8hqkrxa78qfa";
  checkFlags = "--test-threads=1";

  meta = with stdenv.lib; {
    description = "Terminal code snippets manager";
    homepage = "https://github.com/out-of-cheese-error/the-way";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ numkem ];
    platforms = platforms.all;
  };
}
