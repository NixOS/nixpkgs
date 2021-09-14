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
  version = "0.6.3";

  src = fetchFromGitHub {
    owner = "sstadick";
    repo = pname;
    rev = "v${version}";
    sha256 = "02yvpgvzdprysg0spa0abn7d3vjj5spzc3528rwbpl4cw2yx8j6w";
  };

  cargoSha256 = "0n6wywb1xyaxkbr0fs39992dfv55wzvp05i1vk9mxgnsim9s7aw8";

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
