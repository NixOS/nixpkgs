{ stdenv, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-sync-readme";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "phaazon";
    repo = pname;
    rev = version;
    sha256 = "1c38q87fyfmj6nlwdpavb1xxpi26ncywkgqcwbvblad15c6ydcyc";
  };

  cargoSha256 = "1x15q6wv5278hm3ns2wmw4i8602g35y1jyv1b8wa5i4dnh52dj83";

  meta = with stdenv.lib; {
    description = "A cargo plugin that generates a Markdown section in your README based on your Rust documentation";
    homepage = "https://github.com/phaazon/cargo-sync-readme";
    license = licenses.bsd3;
    maintainers = with maintainers; [ b4dm4n ];
  };
}
