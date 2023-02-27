{ lib
, rustPlatform
, fetchFromGitHub
, cmake
}:

rustPlatform.buildRustPackage rec {
  pname = "hck";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "sstadick";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-wsuXEHwnTP+vl8Gn1mfH+cKoasDdZ+ILiAaJ7510lsI=";
  };

  cargoSha256 = "sha256-qWat0QIMLmMrbK/QCr3dSyWP27wFFQ+IDQAzLngThQE=";

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "A close to drop in replacement for cut that can use a regex delimiter instead of a fixed string";
    homepage = "https://github.com/sstadick/hck";
    changelog = "https://github.com/sstadick/hck/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ mit /* or */ unlicense ];
    maintainers = with maintainers; [ figsoda ];
  };
}
