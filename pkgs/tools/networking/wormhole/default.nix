{ stdenv
, rustPlatform
, fetchFromGitHub
, openssl
, pkg-config
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "wormhole";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "agrinman";
    repo = pname;
    rev = version;
    sha256 = "0aq2myzqd9xqz4zdl03jhdd7f22y9k39xdhiark6ymhwcxijsq8y";
  };

  cargoSha256 = "1gjqiv8sgdab0i461v72zcvh91cpqmmpcc3qyx3svq0391rwzp46";

  nativeBuildInputs = stdenv.lib.optionals stdenv.isLinux [ pkg-config ];
  buildInputs = [ ]
    ++ stdenv.lib.optionals stdenv.isLinux [ openssl ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ Security ];

  meta = with stdenv.lib; {
    description = "Expose your local web server to the internet with a public URL";
    homepage = "https://tunnelto.dev";
    license = licenses.mit;
    maintainers = with maintainers; [ filalex77 ];
  };
}
