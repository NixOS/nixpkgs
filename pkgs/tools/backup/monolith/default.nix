{ stdenv
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "monolith";
  version = "2.2.7";

  src = fetchFromGitHub {
    owner = "Y2Z";
    repo = pname;
    rev = "v${version}";
    sha256 = "1ww5q7pk269l2s7d2svkkyd7hb7g4hqmwjn09b287pmjcirnmqn9";
  };

  cargoSha256 = "0jdbxshvm9hdxdjr3sy1kgszhfs9v4r6gp0nwvv2n92m3z8zri9y";

  nativeBuildInputs = stdenv.lib.optionals stdenv.isLinux [ pkg-config ];
  buildInputs = stdenv.lib.optionals stdenv.isLinux [ openssl ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ Security ];

  checkFlagsArray = [ "--skip=tests::cli" ];

  meta = with stdenv.lib; {
    description = "Bundle any web page into a single HTML file";
    homepage = "https://github.com/Y2Z/monolith";
    license = licenses.unlicense;
    maintainers = with maintainers; [ filalex77 ];
  };
}
