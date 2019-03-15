{ stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  name = "lsd-${version}";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "Peltoche";
    repo = "lsd";
    rev = version;
    sha256 = "0s0pgnhzhkjm78cp12jscpld0m2mslin5yb273wzdvx4wax2s17z";
  };

  cargoSha256 = "0pg4wsk2qaljrqklnl5p3iv83314wmybyxsn1prvsjsl4b64mil9";

  preFixup = ''
    install -Dm644 -t $out/share/zsh/site-functions/ target/release/build/lsd-*/out/_lsd
    install -Dm644 -t $out/share/fish/vendor_completions.d/ target/release/build/lsd-*/out/lsd.fish
    install -Dm644 -t $out/share/bash-completion/completions/ target/release/build/lsd-*/out/lsd.bash
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/Peltoche/lsd;
    description = "The next gen ls command";
    license = licenses.asl20;
    maintainers = [ maintainers.marsam ];
  };
}
