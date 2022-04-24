{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "go-license-detector";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "src-d";
    repo = pname;
    rev = "v${version}";
    sha256 = "0ln1z3y9q5igf9djkxw05ql2hb1ijcvvz0mrbwz11cdv9xrsa4z4";
  };

  vendorSha256 = "0gan5l7vsq0hixxcymhhs8p07v92w60r0lhgvrr9a99nic12vmia";

  doCheck = false;

  meta = with lib; {
    description = "Reliable project licenses detector";
    homepage = "https://github.com/src-d/go-license-detector";
    license = licenses.asl20;
    maintainers = with maintainers; [ dtzWill ];
    mainProgram = "license-detector";
  };
}
