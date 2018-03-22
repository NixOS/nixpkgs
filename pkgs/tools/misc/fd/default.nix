{ stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  name = "fd-${version}";
  version = "6.3.0";

  src = fetchFromGitHub {
    owner = "sharkdp";
    repo = "fd";
    rev = "v${version}";
    sha256 = "1q666k7rssjd2cbkm8bm2gsn5shlkh756qpam53kibi5ahrwa7dc";
  };

  cargoSha256 = "1dikix9d46f0ydi81ray2vdvsy6y326w8ql6c89zx0p9cjm8m83r";

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
