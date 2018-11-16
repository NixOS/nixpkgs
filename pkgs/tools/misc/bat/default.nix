{ stdenv, rustPlatform, fetchFromGitHub, cmake, pkgconfig, zlib
, Security, libiconv
}:

rustPlatform.buildRustPackage rec {
  name    = "bat-${version}";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner  = "sharkdp";
    repo   = "bat";
    rev    = "v${version}";
    sha256 = "13c88h1m9flmx3x2h7xrnb1wy4vgdxsqahw8cqa0x61ay0019a7s";
    fetchSubmodules = true;
  };

  cargoSha256 = "1clng4rl7mq50z8d5ipmr9fapjj4qmpf4gmdnfl6vs35pq3wp9j4";

  nativeBuildInputs = [ cmake pkgconfig zlib ];

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ Security libiconv ];

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
