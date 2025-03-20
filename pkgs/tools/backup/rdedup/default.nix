{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
  libsodium,
  xz,
  Security,
}:

rustPlatform.buildRustPackage rec {
  pname = "rdedup";
  version = "3.2.1";

  src = fetchFromGitHub {
    owner = "dpc";
    repo = "rdedup";
    rev = "v${version}";
    sha256 = "sha256-GEYP18CaCQShvCg8T7YTvlybH1LNO34KBxgmsTv2Lzs=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-JpsUceR9Y3r6RiaLOtbgBUrb6eoan7fFt76U9ztQoM8=";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];
  buildInputs = [
    openssl
    libsodium
    xz
  ] ++ (lib.optional stdenv.hostPlatform.isDarwin Security);

  meta = with lib; {
    description = "Data deduplication with compression and public key encryption";
    mainProgram = "rdedup";
    homepage = "https://github.com/dpc/rdedup";
    license = licenses.mpl20;
    maintainers = with maintainers; [ dywedir ];
  };
}
