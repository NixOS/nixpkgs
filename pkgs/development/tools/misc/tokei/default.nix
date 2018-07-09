{ stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  name = "tokei-${version}";
  version = "7.0.3";

  src = fetchFromGitHub {
    owner = "Aaronepower";
    repo = "tokei";
    rev = "v${version}";
    sha256 = "1n2ddwmyd414p6a98khq8y0bmljwcclw30wy5zy5b6z1l40yxcza";
  };

  cargoSha256 = "0ngqk8nnw00s25y91vgsl37j26xl2ws75l3lvklf9gbd4bi01crv";

  meta = with stdenv.lib; {
    description = "Count code, quickly";
    homepage = https://github.com/Aaronepower/tokei;
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ gebner ];
    platforms = platforms.all;
  };
}
