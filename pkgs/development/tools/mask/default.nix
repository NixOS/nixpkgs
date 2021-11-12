{ fetchFromGitHub, lib, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "mask";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "jakedeichert";
    repo = pname;
    rev = "v${version}";
    sha256 = "0gsfs837nzh71df6p6klcsgxp471c8hq14xqd62q5bsv7jg9dygc";
  };

  cargoSha256 = "1h4sasqdl3rli0v6lizdci0vvr2fvbyhllddxwv8vx8r7w9ry963";

  # tests require mask to be installed
  doCheck = false;

  meta = with lib; {
    description = "A CLI task runner defined by a simple markdown file";
    homepage = "https://github.com/jakedeichert/mask";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
