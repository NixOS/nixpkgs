{ lib
, rustPlatform
, fetchFromGitHub
, cmake
}:

rustPlatform.buildRustPackage rec {
  pname = "hck";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "sstadick";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-KPpvai7+El2JA97EXDCstZ66FeyVCe7w+ERDDNRZ/h8=";
  };

  cargoSha256 = "sha256-TpwUO0BL8kambnxAUE9+l6YYkNL1WzmkTYn1YxjufdY=";

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "A close to drop in replacement for cut that can use a regex delimiter instead of a fixed string";
    homepage = "https://github.com/sstadick/hck";
    changelog = "https://github.com/sstadick/hck/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ mit /* or */ unlicense ];
    maintainers = with maintainers; [ figsoda ];
  };
}
