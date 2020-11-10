{ stdenv
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "monolith";
  version = "2.3.1";

  src = fetchFromGitHub {
    owner = "Y2Z";
    repo = pname;
    rev = "v${version}";
    sha256 = "16k5mp64a5l063rdj65hbpx414xv0bqdvhvz49k8018f2a2jj5xl";
  };

  cargoSha256 = "0s5mv8mymycz4ga4zh9kbrhwmhgl4j01pw1sdzxy49l9waryk9p3";

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
