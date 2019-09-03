{ lib
, fetchFromGitHub
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "uq";
  version = "unstable-2018-05-27";

  src = fetchFromGitHub {
    owner = "lostutils";
    repo = "uq";
    rev = "118bc2f3b1cf292afdffbc1cb4415d150b323165";
    sha256 = "1qqqmdk0v1d3ckasmmw5lbrkvhkv0nws4bzi9cfi1ndhrbvbkbxb";
  };

  cargoSha256 = "1s22v2wz5h3l5l447zl54bhdk6avkk2ycrbbpxcx1442lllbss4w";

  meta = with lib; {
    description = "A simple, user-friendly alternative to sort | uniq";
    homepage = "https://github.com/lostutils/uq";
    license = licenses.mit;
    maintainers = with maintainers; [ doronbehar ];
    platforms = platforms.all;
  };
}
