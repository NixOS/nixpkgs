{
  lib,
  fetchFromGitHub,
  rustPlatform,
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

  cargoSha256 = "1p6008vxm2pi9v31qhsq7zysanal6rcvcl8553373bkqlfd7w5c4";

  meta = with lib; {
    description = "A simple, user-friendly alternative to sort | uniq";
    homepage = "https://github.com/lostutils/uq";
    license = licenses.mit;
    maintainers = with maintainers; [
      doronbehar
      matthiasbeyer
    ];
    mainProgram = "uq";
  };
}
