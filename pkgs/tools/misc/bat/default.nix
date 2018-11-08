{ stdenv, rustPlatform, fetchFromGitHub, cmake, pkgconfig, zlib
, Security, libiconv
}:

rustPlatform.buildRustPackage rec {
  name    = "bat-${version}";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner  = "sharkdp";
    repo   = "bat";
    rev    = "v${version}";
    sha256 = "1xvjw61q0qbnzj95g7g8xckcqha9jrf2172b5l7faj7i0jhmz2kx";
    fetchSubmodules = true;
  };

  cargoSha256 = "0xv769f2iqrgnbmb7ma9p3gbb2xpx2lhqc0kq5nizf8w8xdc5m11";

  nativeBuildInputs = [ cmake pkgconfig zlib ];

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ Security libiconv ];

  # https://github.com/NixOS/nixpkgs/issues/49642
  doCheck = !stdenv.isDarwin;

  postInstall = ''
    install -m 444 -Dt $out/share/man/man1 doc/bat.1

    install -Dm644 target/release/build/bat-*/out/_bat \
      "$out/share/zsh/site-functions/_bat"
    install -Dm644 target/release/build/bat-*/out/bat.bash \
      "$out/share/bash-completions/completions/bat.bash"
    install -Dm644 target/release/build/bat-*/out/bat.fish \
      "$out/share/fish/vendor_completions.d/bat.fish"
  '';

  meta = with stdenv.lib; {
    description = "A cat(1) clone with syntax highlighting and Git integration";
    homepage    = https://github.com/sharkdp/bat;
    license     = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ dywedir ];
    platforms   = platforms.linux ++ platforms.darwin;
  };
}
