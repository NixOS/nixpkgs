{ cmake
, fetchFromGitHub
, lib
, rustPlatform
, stdenv
, libiconv
, CoreFoundation
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "hck";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "sstadick";
    repo = pname;
    rev = "v${version}";
    sha256 = "1xjp56asfn37kr0fsrjkil20nf372q70cijqb5ll2sq2zwjnyyzn";
  };

  cargoSha256 = "12n33gwxcym5z5n762wmzcck4zmmn42kh04nwpdb3az4apghdp3z";

  nativeBuildInputs = [ cmake ];

  buildInputs = lib.optionals stdenv.isDarwin [ libiconv CoreFoundation Security ];

  meta = with lib; {
    description = "A close to drop in replacement for cut that can use a regex delimiter instead of a fixed string";
    homepage = "https://github.com/sstadick/hck";
    changelog = "https://github.com/sstadick/hck/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ mit /* or */ unlicense ];
    maintainers = with maintainers; [ figsoda ];
  };
}
