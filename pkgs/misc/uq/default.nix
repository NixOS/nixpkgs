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

  cargoSha256 = "1fv13rbghfw7114h7sda04gpqrjrsgnnki0p9kdd6r6sk5cbhn9x";

  meta = with lib; {
    description = "A simple, user-friendly alternative to sort | uniq";
    homepage = "https://github.com/lostutils/uq";
    license = licenses.mit;
    maintainers = with maintainers; [ doronbehar ];
    platforms = platforms.all;
  };
}
