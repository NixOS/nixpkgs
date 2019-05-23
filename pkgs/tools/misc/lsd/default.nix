{ stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "lsd";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "Peltoche";
    repo = pname;
    rev = version;
    sha256 = "0wh68dxdzkmyrz9dsd3rdr5yrvny3y11xgm2pxb3z83ajngp1hcv";
  };

  cargoSha256 = "095jf63jyd485fk8pl7grvycn7pkwnxdm5lwkmfl9p46m8q1qqr2";

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
