{ stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  name = "fd-${version}";
  version = "7.1.0";

  src = fetchFromGitHub {
    owner = "sharkdp";
    repo = "fd";
    rev = "v${version}";
    sha256 = "11x9zqhahgyf0icfnl8xzdb2mn35jrmvxmnz5xzh581mmhs355m2";
  };

  cargoSha256 = "02r0lvfh37y1bij0fqmgyh8rywap714zvxrk0l108y8cqkq2ghnd";

  preFixup = ''
    mkdir -p "$out/man/man1"
    cp "$src/doc/fd.1" "$out/man/man1"

    mkdir -p "$out/share/"{bash-completion/completions,fish/vendor_completions.d,zsh/site-functions}
    cp target/release/build/fd-find-*/out/fd.bash "$out/share/bash-completion/completions/"
    cp target/release/build/fd-find-*/out/fd.fish "$out/share/fish/vendor_completions.d/"
    cp target/release/build/fd-find-*/out/_fd "$out/share/zsh/site-functions/"
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
    maintainers = with maintainers; [ dywedir ];
    platforms = platforms.all;
  };
}
