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
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "sstadick";
    repo = pname;
    rev = "v${version}";
    sha256 = "1l1v02rvb30bcq13ww56k04nc231f7q73zgf281974d6s2qwjdwh";
  };

  cargoSha256 = "1isgbzi8afbr2xkw70nxakwcb5zjzw28rgp4p7ammhfxjjxw7y93";

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
