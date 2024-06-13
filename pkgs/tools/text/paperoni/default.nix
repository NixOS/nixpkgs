{ lib
, rustPlatform
, fetchFromGitHub
, curl
, stdenv
, pkg-config
, zlib
, openssl
}:

rustPlatform.buildRustPackage rec {
  pname = "paperoni";
  version = "0.6.1-alpha1";

  src = fetchFromGitHub {
    owner = "hipstermojo";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-vTylnDtoPpiRtk/vew1hLq3g8pepWRVqBEBnvSif4Zw=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  nativeBuildInputs = [
    curl
  ] ++ lib.optionals stdenv.isLinux [
    pkg-config
  ];

  buildInputs = [
    curl
    zlib
  ] ++ lib.optionals stdenv.isLinux [
    openssl
  ];

  # update Cargo.lock to work with openssl 3
  postPatch = ''
    ln -sf ${./Cargo.lock} Cargo.lock
  '';

  meta = with lib; {
    description = "Article extractor in Rust";
    mainProgram = "paperoni";
    homepage = "https://github.com/hipstermojo/paperoni";
    changelog = "https://github.com/hipstermojo/paperoni/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
