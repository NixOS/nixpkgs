{ stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  version = "1.0.1";
  name = "oxipng-${version}";

  src = fetchFromGitHub {
    owner = "shssoichiro";
    repo = "oxipng";
    rev = "v${version}";
    sha256 = "0w39f0dhq9cxk25vy0wh8vicxyckvj1vmglx5va4550i3q0hsrws";
  };

  cargoSha256 = "00nbx6n73yl4ax05pqkmim1vhy0pymgz5la1cc4y18gjbjjj9w4h";

  meta = with stdenv.lib; {
    homepage = https://github.com/shssoichiro/oxipng;
    description = "A lossless PNG compression optimizer";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
