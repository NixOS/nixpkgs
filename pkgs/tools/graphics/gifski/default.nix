{ lib, rustPlatform, fetchFromGitHub, pkg-config }:

rustPlatform.buildRustPackage rec {
  pname = "gifski";
  version = "1.3.3";

  src = fetchFromGitHub {
    owner = "ImageOptim";
    repo = "gifski";
    rev = version;
    sha256 = "sha256-dBgDIS6U2iKzyo5nO0NOD488zfEbaZJH7luJN6khrnc=";
  };

  cargoSha256 = "sha256-/i5ZBCWFlhoheHsCI5f9yJ7sa6l/DB4AJckq5orinwI=";

  nativeBuildInputs = [ pkg-config ];

  meta = with lib; {
    description = "GIF encoder based on libimagequant (pngquant)";
    homepage = "https://gif.ski/";
    license = licenses.agpl3;
    maintainers = [ maintainers.marsam ];
  };
}
