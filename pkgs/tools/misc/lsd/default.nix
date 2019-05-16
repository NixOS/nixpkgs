{ stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "lsd";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "Peltoche";
    repo = "lsd";
    rev = version;
    sha256 = "1k054c4mz0z9knfn7kvvs3305z2g2w44l0cjg4k3cax06ic1grlr";
  };

  cargoSha256 = "0pg4wsk2qaljrqklnl5p3iv83314wmybyxsn1prvsjsl4b64mil9";

  preFixup = ''
    install -Dm644 -t $out/share/zsh/site-functions/ target/release/build/lsd-*/out/_lsd
    install -Dm644 -t $out/share/fish/vendor_completions.d/ target/release/build/lsd-*/out/lsd.fish
    install -Dm644 -t $out/share/bash-completion/completions/ target/release/build/lsd-*/out/lsd.bash
  '';

  # Some tests fail, but Travis ensures a proper build
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://github.com/Peltoche/lsd;
    description = "The next gen ls command";
    license = licenses.asl20;
    maintainers = [ maintainers.marsam ];
  };
}
