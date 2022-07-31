{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "sfz";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "weihanglo";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-XY1xsQgXzmX8jmDDLIivXeW9MsNA/pVtYapcBkBhldE=";
  };

  cargoSha256 = "sha256-w3HKnCAPSVgx4mqNB7Q0sMCDC4U+4fdIUUwJFz19XdI=";

  # error: Found argument '--test-threads' which wasn't expected, or isn't valid in this context
  doCheck = false;

  meta = with lib; {
    description = "Simple static file serving command-line tool written in Rust";
    homepage = "https://github.com/weihanglo/sfz";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ dit7ya ];
  };
}
