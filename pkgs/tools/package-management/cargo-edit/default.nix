{ stdenv
, lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
, libiconv
, Security
, zlib
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-edit";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "killercup";
    repo = pname;
    rev = "v${version}";
    hash = "sha256:0fh1lq793k4ddpqsf2av447hcb74vcq53afkm3g4672k48mjjw1y";
  };

  cargoSha256 = "1h1sy54p7zxijydnhzvkxli90d72biv1inni17licb0vb9dihmnf";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl zlib ] ++ lib.optionals stdenv.isDarwin [
    libiconv
    Security
  ];

  doCheck = false; # integration tests depend on changing cargo config

  meta = with lib; {
    description = "A utility for managing cargo dependencies from the command line";
    homepage = "https://github.com/killercup/cargo-edit";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ gerschtli jb55 filalex77 killercup ];
  };
}
