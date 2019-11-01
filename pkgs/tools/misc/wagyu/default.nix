{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "wagyu";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "ArgusHQ";
    repo = pname;
    rev = "v${version}";
    sha256 = "1646j0lgg3hhznifvbkvr672p3yqlcavswijawaxq7n33ll8vmcn";
  };

  cargoSha256 = "10b96l0b32zxq0xrnhivv3gihmi5y31rllbizv67hrg1axz095vn";
  verifyCargoDeps = true;

  meta = with lib; {
    description = "Rust library for generating cryptocurrency wallets";
    homepage = https://github.com/ArgusHQ/wagyu;
    license = with licenses; [ mit asl20 ];
    maintainers = [ maintainers.offline ];
  };
}
