{ stdenv
, rustPlatform
, fetchFromGitHub
, pkg-config
, zlib
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "miniserve";
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "svenstaro";
    repo = "miniserve";
    rev = "v${version}";
    sha256 = "0d3jfxlk6r52ikqlvrj34grj2anq6r8653icn1dsjcrnwam5vn39";
  };

  cargoSha256 = "0zzfx7j36cxjx8vbcghg5icimda7lwm2qhlnvxcd67fws3ggmn5x";

  nativeBuildInputs = [ pkg-config zlib ];
  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ Security ];

  meta = with stdenv.lib; {
    description = "For when you really just want to serve some files over HTTP right now!";
    homepage = "https://github.com/svenstaro/miniserve";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ zowoq ];
    platforms = platforms.unix;
  };
}
