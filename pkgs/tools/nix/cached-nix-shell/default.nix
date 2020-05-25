{ stdenv, fetchFromGitHub, openssl, pkgconfig, ronn, rustPlatform }:

let 
  blake3-src = fetchFromGitHub {
    owner = "BLAKE3-team";
    repo = "BLAKE3";
    rev = "0.3.1";
    sha256 = "0wkxx2w56hsng28p8zpndsy288ix4s5qg6xqjzgjz53fbyk46hda";
  };

in rustPlatform.buildRustPackage rec {
  pname = "cached-nix-shell";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "xzfc";
    repo = pname;
    rev = "v${version}";
    sha256 = "0pzwknpc4qrh9pv5z0xvldql2dkj9ddksvaci86a4f8cnd86p2l6";
  };

  cargoSha256 = "1n88gcnrfdrk025hb54igc83cn5vlv8n6ndyx1ydmzhd95vhbznf";

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
    cp target/release/build/cached-nix-shell-*/out/trace-nix.so $out/lib
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
