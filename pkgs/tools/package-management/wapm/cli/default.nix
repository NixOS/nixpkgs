{ fetchFromGitHub
, openssl
, rustPlatform
, Security
, stdenv
}:

rustPlatform.buildRustPackage rec {
  pname = "wapm-cli";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "wasmerio";
    repo = "wapm-cli";
    rev = "v${version}";
    sha256 = "0w0ck60xm47b93y803i2b2bpv7nsahzvzda3ll7pjg88f8qz5fx1";
  };

  buildInputs = stdenv.lib.optionals stdenv.isLinux [ openssl ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ Security ];

  meta = with stdenv.lib; {
    description = "A package manager for WebAssembly modules";
    homepage = "https://docs.wasmer.io/ecosystem/wapm";
    license = with licenses; [ mit ];
    maintainers = [ maintainers.lucperkins ];
    platforms = platforms.all;
  };
}
