{ stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  version = "2.1.8";
  name = "oxipng-${version}";

  src = fetchFromGitHub {
    owner = "shssoichiro";
    repo = "oxipng";
    rev = "v${version}";
    sha256 = "18ld65vm58s6x918g6bhfkrg7lw2lca8daidv88ff14wm5khjvik";
  };

  cargoSha256 = "034i8hgi0zgv085bimlja1hl3nd096rqpi167pw6rda5aj18c625";

  meta = with stdenv.lib; {
    homepage = https://github.com/shssoichiro/oxipng;
    description = "A multithreaded lossless PNG compression optimizer";
    license = licenses.mit;
    maintainers = with maintainers; [ dywedir ];
    platforms = platforms.all;

    # Needs newer/unstable rust: error[E0658]: macro is_arm_feature_detected! is unstable
    broken = stdenv.isAarch64;
  };
}
