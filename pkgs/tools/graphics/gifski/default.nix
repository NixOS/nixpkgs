{ stdenv, rustPlatform, fetchFromGitHub, pkgconfig }:

rustPlatform.buildRustPackage rec {
  pname = "gifski";
  version = "0.8.7";

  src = fetchFromGitHub {
    owner = "ImageOptim";
    repo = "gifski";
    rev = version;
    sha256 = "0x41gyc5jk45jlx0hcq80j5gj1f66lcmbclqyx70l43ggslsi26f";
  };

  cargoSha256 = "1pik6jcxg3amb5widpxn8j9szghbrhl0wsxjisizas3033xzrhcf";

  nativeBuildInputs = [ pkgconfig ];

  meta = with stdenv.lib; {
    description = "GIF encoder based on libimagequant (pngquant)";
    homepage = https://gif.ski/;
    license = licenses.agpl3;
    maintainers = [ maintainers.marsam ];
  };
}
