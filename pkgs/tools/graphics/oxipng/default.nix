{ stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  version = "2.1.6";
  name = "oxipng-${version}";

  src = fetchFromGitHub {
    owner = "shssoichiro";
    repo = "oxipng";
    rev = "v${version}";
    sha256 = "0n3v2dxybfkf07hb4p2hbhhkwx907b85wzj8wa4whwil89igyrdm";
  };

  cargoSha256 = "1ycacwhwbn27i81jpp55m1446b9a50knlqv0kzkjcv8yf27213y9";

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
