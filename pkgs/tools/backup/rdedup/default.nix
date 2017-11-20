{ stdenv, fetchFromGitHub, rustPlatform, pkgconfig, libsodium, lzma }:

rustPlatform.buildRustPackage rec {
  name = "rdedup-${version}";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "dpc";
    repo = "rdedup";
    rev = "v${version}";
    sha256 = "14r6x1wi5mwadarm0vp6qnr5mykv4g0kxz9msq76fhwghwb9k1d9";
  };

  buildInputs = [ pkgconfig libsodium lzma ];

  cargoSha256 = "0wyswc4b4hkiw20gz0w94vv1qgcb2zq0cdaj9zxvyr5l0abxip9w";

  meta = with stdenv.lib; {
    description = "Data deduplication with compression and public key encryption";
    homepage = https://github.com/dpc/rdedup;
    license = licenses.mpl20;
    maintainers = with maintainers; [ dywedir ];
    platforms = platforms.all;
  };
}
