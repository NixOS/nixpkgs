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

  cargoSha256 = "02aij40wqyjg2mzzs6ikfrm17z84lgdq8nxh2j5q00j2vn6sk46i";
  verifyCargoDeps = true;

  meta = with lib; {
    description = "Rust library for generating cryptocurrency wallets";
    homepage = https://github.com/ArgusHQ/wagyu;
    license = with licenses; [ mit asl20 ];
    maintainers = [ maintainers.offline ];
  };
}
