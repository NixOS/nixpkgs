{ lib, stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "docui";
  version = "2.0.4";

  src = fetchFromGitHub {
    owner = "skanehira";
    repo = "docui";
    rev = version;
    sha256 = "0jya0wdp8scjmsr44krdbbb8q4gplf44gsng1nyn12a6ldqzayxl";
  };

  vendorSha256 = "1ggdczvv03lj0g6cq26vrk1rba6pk0805n85w9hkbjx9c4r3j577";

  meta = with lib; {
    description = "TUI Client for Docker";
    homepage = "https://github.com/skanehira/docui";
    license = licenses.mit;
    maintainers = with maintainers; [ aethelz ];
    broken = stdenv.isDarwin;
  };
}
