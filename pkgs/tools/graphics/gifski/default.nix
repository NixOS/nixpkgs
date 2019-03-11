{ stdenv, rustPlatform, fetchFromGitHub, pkgconfig }:

rustPlatform.buildRustPackage rec {
  name = "gifski-${version}";
  version = "0.8.7";

  src = fetchFromGitHub {
    owner = "ImageOptim";
    repo = "gifski";
    rev = version;
    sha256 = "0x41gyc5jk45jlx0hcq80j5gj1f66lcmbclqyx70l43ggslsi26f";
  };

  cargoSha256 = "0rgcm9kj9wapn8y3ymcm1n713r0a9bvgm339y302f5gy76gbgzrk";

  nativeBuildInputs = [ pkgconfig ];

  meta = with stdenv.lib; {
    description = "GIF encoder based on libimagequant (pngquant)";
    homepage = https://gif.ski/;
    license = licenses.agpl3;
    maintainers = [ maintainers.marsam ];
  };
}
