{ stdenv
, fetchFromGitHub
, rustPlatform
, pkgconfig
, openssl
, curl
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "wasm-pack";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "rustwasm";
    repo = "wasm-pack";
    rev = "v${version}";
    sha256 = "1z66m16n4r16zqmnv84a5jndr5x6mdqdq4b1wq929sablwqd2rl4";
  };

  cargoSha256 = "0hp68w5mvk725gzbmlgl8j6wa1dv2fydil7jvq0f09mzxxaqrwcs";

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ openssl ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ curl Security ];


  # Tests fetch external resources and build artifacts.
  # Disabled to work with sandboxing
  doCheck = false;

  meta = with stdenv.lib; {
    description = "A utility that builds rust-generated WebAssembly package";
    homepage = https://github.com/rustwasm/wasm-pack;
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = [ maintainers.dhkl ];
    platforms = platforms.all;
  };
}
