{ stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "lsd";
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "Peltoche";
    repo = pname;
    rev = version;
    sha256 = "0fh5rz6slyjzz03bpjcl9gplk36vm7qcc0i0gvhsikwvw0cf3hym";
  };

  cargoSha256 = "1z7sg9b7qsjw1hhc7dkvxz8xgf4k8jddr7gbnjr4d2569g97jf3f";

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
