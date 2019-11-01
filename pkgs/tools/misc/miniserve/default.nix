{ stdenv, rustPlatform, fetchFromGitHub, cmake, pkgconfig, zlib }:

rustPlatform.buildRustPackage rec {
  pname = "miniserve";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner  = "svenstaro";
    repo   = "miniserve";
    rev    = "v${version}";
    sha256 = "1g8ggqs4fyscb1r98qj22f61jgkqnr4vdyps0drrvydl9lafdmpl";
  };

  cargoSha256 = "055mbrzg7v8a65awn1051b4b9ngxq25wy31gjq8kc93qsb7k0f2k";

  nativeBuildInputs = [ cmake pkgconfig zlib ];

  meta = with stdenv.lib; {
    description = "For when you really just want to serve some files over HTTP right now!";
    homepage    = https://github.com/svenstaro/miniserve;
    license     = with licenses; [ mit ];
    maintainers = with maintainers; [ nequissimus ];
    platforms   = platforms.linux;
  };
}
