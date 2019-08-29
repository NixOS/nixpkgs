{ stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  name = "fd-${version}";
  version = "7.3.0";

  src = fetchFromGitHub {
    owner = "sharkdp";
    repo = "fd";
    rev = "v${version}";
    sha256 = "0y4657w1pi4x9nmbv551dj00dyiv935m8ph7jlv00chwy3hrb3yi";
  };

  cargoSha256 = "1qqlii9693ih7pxl80v515a13jar3yayr5v7pa57x14i9syir10c";

  preFixup = ''
    install -Dm644 "$src/doc/fd.1" "$out/man/man1/fd.1"

    install -Dm644 target/release/build/fd-find-*/out/fd.bash \
      "$out/share/bash-completion/completions/fd.bash"
    install -Dm644 target/release/build/fd-find-*/out/fd.fish \
      "$out/share/fish/vendor_completions.d/fd.fish"
    install -Dm644 target/release/build/fd-find-*/out/_fd \
      "$out/share/zsh/site-functions/_fd"
  '';

  meta = with stdenv.lib; {
    description = "A simple, fast and user-friendly alternative to find";
    longDescription = ''
      `fd` is a simple, fast and user-friendly alternative to `find`.

      While it does not seek to mirror all of `find`'s powerful functionality,
      it provides sensible (opinionated) defaults for 80% of the use cases.
    '';
    homepage = "https://github.com/sharkdp/fd";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ dywedir globin ];
    platforms = platforms.all;
  };
}
