{ stdenv
, rustPlatform
, fetchFromGitHub
, pkg-config
, zlib
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "miniserve";
  version = "0.10.4";

  src = fetchFromGitHub {
    owner = "svenstaro";
    repo = "miniserve";
    rev = "v${version}";
    sha256 = "0hskb72gnp66vkyxsqnxhjcqgvjj7wbd2nm5wxp94abc5l1fiigv";
  };

  cargoSha256 = "0s1gdngpf6gxz2lyapblxxmc6aydg2i9kmrfvngkbmqh4as1a2vl";

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
