{ stdenv, rustPlatform, fetchFromGitHub, pkgconfig }:

rustPlatform.buildRustPackage rec {
  pname = "gifski";
  version = "0.10.2";

  src = fetchFromGitHub {
    owner = "ImageOptim";
    repo = "gifski";
    rev = version;
    sha256 = "0gsk1pagg89q1mi3d28q6dsnanncwphw9lrb7qybppw0vyvqlqbx";
  };

  cargoSha256 = "0k7pzcll7hn2a354vviyj8dr0kq63cwsldgv303kwklmxji02d0v";

  nativeBuildInputs = [ pkgconfig ];

  meta = with stdenv.lib; {
    description = "GIF encoder based on libimagequant (pngquant)";
    homepage = "https://gif.ski/";
    license = licenses.agpl3;
    maintainers = [ maintainers.marsam ];
  };
}
