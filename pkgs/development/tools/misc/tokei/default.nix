{ stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  name = "tokei-${version}";
  version = "9.0.0";

  src = fetchFromGitHub {
    owner = "Aaronepower";
    repo = "tokei";
    rev = "v${version}";
    sha256 = "04d32w3yc98f6swxap19d6vrv8vi3w843cgnmf28mxcy4nbnls1n";
  };

  cargoSha256 = "0vjb4j8qwlmvw55i2jif1a7hwv928h90dzwlpcqb0h6nlv812fav";

  meta = with stdenv.lib; {
    description = "Program that displays statistics about your code";
    homepage = https://github.com/Aaronepower/tokei;
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ gebner ];
    platforms = platforms.all;
  };
}
