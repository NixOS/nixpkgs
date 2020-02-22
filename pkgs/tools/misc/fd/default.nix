{ stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "fd";
  version = "7.4.0";

  src = fetchFromGitHub {
    owner = "sharkdp";
    repo = "fd";
    rev = "v${version}";
    sha256 = "108p1p9bxhg4qzwfs6wqcakcvlpqw3w498jkz1vhmg6jp1mbmgdr";
  };

  # Delete this on next update; see #79975 for details
  legacyCargoFetcher = true;

  cargoSha256 = "0ylanxcb1vrhvm9h3lvq8nh28362wi5hjy0pqdv5lh40pphcknnz";

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
