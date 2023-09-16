{ lib
, fetchFromGitHub
, libarchive
, openssl
, pkg-config
, python3
, rust
, rustPlatform
, tpm2-tss
}:

rustPlatform.buildRustPackage rec {
  pname = "rust-keylime";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "keylime";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-QmqzyhdXVhSv3t+3nNI4mehLEHgjTj3Mm8XXYTjZ0EI=";
  };

  cargoHash = "sha256-F7251TiQmiATK8RB4++n0esVVj8bvLXWJZ6BKT6OwLQ=";

  patches = [
    ./fix-python-env.patch
  ];

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
    python3
  ];

  buildInputs = [
    libarchive
    openssl
    tpm2-tss
  ];

  nativeCheckInputs = [
    rustPlatform.cargoCheckHook
  ];

  checkInputs = [
    python3
  ];

  postPatch = ''
   patchShebangs keylime-agent/tests/actions/*.py
   patchShebangs keylime-agent/tests/unzipped/*.py
  '';

  postInstall = ''
    mkdir -p "$out/etc/keylime/agent.conf.d/"
    cp "keylime-agent.conf" "$out/etc/keylime/agent.conf"
  '';

  meta = with lib; {
    description = "Rust implementation of the keylime agent";
    homepage = "https://github.com/keylime/rust-keylime";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ arkivm ];
  };
}
