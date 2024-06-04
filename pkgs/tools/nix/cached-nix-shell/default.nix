{ lib, fetchFromGitHub, nix, ronn, rustPlatform }:

let
  blake3-src = fetchFromGitHub {
    owner = "BLAKE3-team";
    repo = "BLAKE3";
    rev = "0.3.3";
    sha256 = "0av41ld0gqf3g60gcllpz59nqlr7r62v99mgfq9gs0p8diw5gi7x";
  };

in rustPlatform.buildRustPackage rec {
  pname = "cached-nix-shell";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "xzfc";
    repo = pname;
    rev = "v${version}";
    sha256 = "17v38llx83mp05a0axjxcd2zyafd57syh7xhx5cq6qibcbha0by9";
  };

  cargoSha256 = "1jkkwsn3k2anmzf99x99r9zfnf0gpcjbi5pyakh4agiryqcdyg0j";

  # The BLAKE3 C library is intended to be built by the project depending on it
  # rather than as a standalone library.
  # https://github.com/BLAKE3-team/BLAKE3/blob/0.3.1/c/README.md#building
  BLAKE3_CSRC = "${blake3-src}/c";

  nativeBuildInputs = [ nix ronn ];

  postBuild = ''
    make -f nix/Makefile post-build
  '';

  postInstall = ''
    make -f nix/Makefile post-install
  '';

  meta = with lib; {
    description = "Instant startup time for nix-shell";
    mainProgram = "cached-nix-shell";
    homepage = "https://github.com/xzfc/cached-nix-shell";
    license = with licenses; [ unlicense /* or */ mit ];
    maintainers = with maintainers; [ xzfc ];
    platforms = platforms.linux;
  };
}
