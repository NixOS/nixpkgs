{ stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "lsd";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "Peltoche";
    repo = pname;
    rev = version;
    sha256 = "1vyww54fl4yfvszr0dh8ym2jd9gilrccmwkvl7rbx70sfqzsgaai";
  };

  cargoSha256 = "13g0p6zh2b1z005lszll098d4lv62dzsxwhl76bianzrydif61lr";

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
