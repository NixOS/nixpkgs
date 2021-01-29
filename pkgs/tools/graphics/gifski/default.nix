{ lib, rustPlatform, fetchFromGitHub, pkg-config }:

rustPlatform.buildRustPackage rec {
  pname = "gifski";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "ImageOptim";
    repo = "gifski";
    rev = version;
    sha256 = "sha256-sB8W5n3FvRAB9ygFg63NecSZgUw8FGk4pzviIbRF2vk=";
  };

  cargoSha256 = "sha256-0cFk1GnEJxMfY9GvQTdI5tkgtxGkH3ZQFTloo4/C+sY=";

  nativeBuildInputs = [ pkg-config ];

  meta = with lib; {
    description = "GIF encoder based on libimagequant (pngquant)";
    homepage = "https://gif.ski/";
    license = licenses.agpl3;
    maintainers = [ maintainers.marsam ];
  };
}
