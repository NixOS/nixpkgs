{ lib, stdenv, fetchFromGitHub, rustPlatform, pkg-config, openssl, libsodium
, xz
, Security }:

rustPlatform.buildRustPackage rec {
  pname = "rdedup";
  version = "3.2.1";

  src = fetchFromGitHub {
    owner = "dpc";
    repo = "rdedup";
    rev = "v${version}";
    sha256 = "sha256-GEYP18CaCQShvCg8T7YTvlybH1LNO34KBxgmsTv2Lzs=";
  };

  cargoHash = "sha256-I6d3IyPBcUsrvlzF7W0hFM4hcXi4wWro9bCeP4eArHI=";

  nativeBuildInputs = [ pkg-config rustPlatform.bindgenHook ];
  buildInputs = [ openssl libsodium xz ]
    ++ (lib.optional stdenv.hostPlatform.isDarwin Security);

  meta = with lib; {
    description = "Data deduplication with compression and public key encryption";
    mainProgram = "rdedup";
    homepage = "https://github.com/dpc/rdedup";
    license = licenses.mpl20;
    maintainers = with maintainers; [ dywedir ];
  };
}
