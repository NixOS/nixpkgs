{ fetchFromGitHub, lib, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "dutree";
  version = "0.2.18";

  src = fetchFromGitHub {
    owner = "nachoparker";
    repo = pname;
    rev = "v${version}";
    sha256 = "1720295nxwr6r5yr6zhk2cw5y2l4w862f5wm9v7jjmf3a840yl8p";
  };

  cargoSha256 = "0gg1w0xx36aswfm0y53nqwwz7zds25ysmklbrc8v2r91j74bhkzw";

  meta = with lib; {
    description = "A tool to analyze file system usage written in Rust";
    homepage = "https://github.com/nachoparker/dutree";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ figsoda ];
  };
}
