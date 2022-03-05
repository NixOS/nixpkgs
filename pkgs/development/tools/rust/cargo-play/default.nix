{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-play";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "fanzeyi";
    repo = pname;
    rev = "v${version}";
    sha256 = "01r00akfmvpzp924yqqybd9s0pwiwxy8vklsg4m9ypzljc3nlv02";
  };

  cargoSha256 = "1xkscd9ci9vlkmbsaxvavrna1xpi16xcf9ri879lw8bdh7sa3nx8";

  # these tests require internet access
  checkFlags = [
    "--skip=dtoa_test"
    "--skip=infer_override"
  ];

  meta = with lib; {
    description = "Run your rust code without setting up cargo";
    homepage = "https://github.com/fanzeyi/cargo-play";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
