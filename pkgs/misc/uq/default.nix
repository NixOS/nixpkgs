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

  cargoSha256 = "0y0s3lb9wz3m5s8y68vwwxvp34xvj3kh39jvbwlg8hwvxzfm5fya";

  meta = with lib; {
    description = "A simple, user-friendly alternative to sort | uniq";
    homepage = "https://github.com/lostutils/uq";
    license = licenses.mit;
    maintainers = with maintainers; [ doronbehar ];
  };
}
