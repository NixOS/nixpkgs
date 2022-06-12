{ fetchFromGitHub, lib, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "mask";
  version = "0.11.1";

  src = fetchFromGitHub {
    owner = "jakedeichert";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-qRN9M/DxkxcF1/dmYqmf3qB8yHzuaN3LRENy1ehgg0c=";
  };

  cargoSha256 = "sha256-7ts63n9aGtaK8INBh11TShOQCVpV+82VADmNbKURv+g=";

  # tests require mask to be installed
  doCheck = false;

  meta = with lib; {
    description = "A CLI task runner defined by a simple markdown file";
    homepage = "https://github.com/jakedeichert/mask";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
