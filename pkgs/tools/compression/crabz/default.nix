{ lib
, rustPlatform
, fetchFromGitHub
, cmake
, stdenv
, libiconv
, CoreFoundation
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "crabz";
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "sstadick";
    repo = pname;
    rev = "v${version}";
    sha256 = "0ch9cqarsakihg9ymbdm0ka6wz77z84n4g6cdlcskczc5g3b9gp9";
  };

  cargoSha256 = "sha256-nrCYlhq/f8gk3NmltAg+xppRJ533ooEpetWvaF2vmP0=";

  nativeBuildInputs = [ cmake ];

  buildInputs = lib.optionals stdenv.isDarwin [
    libiconv
    CoreFoundation
    Security
  ];

  meta = with lib; {
    description = "A cross platform, fast, compression and decompression tool";
    homepage = "https://github.com/sstadick/crabz";
    changelog = "https://github.com/sstadick/crabz/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ unlicense /* or */ mit ];
    maintainers = with maintainers; [ figsoda ];
  };
}
