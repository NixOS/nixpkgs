{ stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  name = "fd-${version}";
  version = "6.1.0";

  src = fetchFromGitHub {
    owner = "sharkdp";
    repo = "fd";
    rev = "v${version}";
    sha256 = "1md6k531ymsg99zc6y8lni4cpfz4rcklwgibq1i5xdam3hs1n2jg";
  };

  cargoSha256 = "00n2j0mjmd4lrfygnv90mixv3hfv1z56zyqcm957cwq08qavqzf1";

  preFixup = ''
    mkdir -p "$out/man/man1"
    cp "$src/doc/fd.1" "$out/man/man1"

    mkdir -p "$out/share/"{bash-completion/completions,fish/completions,zsh/site-functions}
    cp target/release/build/fd-find-*/out/fd.bash "$out/share/bash-completion/completions/"
    cp target/release/build/fd-find-*/out/fd.fish "$out/share/fish/completions/"
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
    platforms = platforms.all;
  };
}
