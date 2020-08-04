{ stdenv, fetchFromGitHub, openssl, pkgconfig, ronn, rustPlatform }:

let
  blake3-src = fetchFromGitHub {
    owner = "BLAKE3-team";
    repo = "BLAKE3";
    rev = "0.3.3";
    sha256 = "0av41ld0gqf3g60gcllpz59nqlr7r62v99mgfq9gs0p8diw5gi7x";
  };

in rustPlatform.buildRustPackage rec {
  pname = "cached-nix-shell";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "xzfc";
    repo = pname;
    rev = "v${version}";
    sha256 = "1ni671wr2lrvyz6myaz3v4llrjvq4jc1ygw1m7rvnadzyf3va3lw";
  };

  cargoSha256 = "19i39b1yqdf81ql4psr3nfah6ci2mw3ljkv740clqmz088j2av8g";

  # The BLAKE3 C library is intended to be built by the project depending on it
  # rather than as a standalone library.
  # https://github.com/BLAKE3-team/BLAKE3/blob/0.3.1/c/README.md#building
  BLAKE3_CSRC = "${blake3-src}/c";

  nativeBuildInputs = [ ronn ];

  postBuild = ''
    ronn -r cached-nix-shell.1.md
  '';

  postInstall = ''
    mkdir -p $out/lib $out/share/cached-nix-shell $out/share/man/man1 $out/var/empty
    cp $releaseDir/build/cached-nix-shell-*/out/trace-nix.so $out/lib
    cp rcfile.sh $out/share/cached-nix-shell/rcfile.sh
    cp cached-nix-shell.1 $out/share/man/man1
  '';

  meta = with stdenv.lib; {
    description = "Instant startup time for nix-shell";
    homepage = "https://github.com/xzfc/cached-nix-shell";
    license = with licenses; [ unlicense /* or */ mit ];
    maintainers = with maintainers; [ xzfc ];
    platforms = platforms.linux;
  };
}
