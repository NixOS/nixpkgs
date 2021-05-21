{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "ipinfo";
  version = "1.1.5";

  src = fetchFromGitHub {
    owner = pname;
    repo = "cli";
    rev = "${pname}-${version}";
    sha256 = "16i5vmx39j7l5mhs28niapki9530nsbw6xik8rsky55v9i5pr72d";
  };

  vendorSha256 = null;

  meta = with lib; {
    description = "Command Line Interface for the IPinfo API";
    homepage = "https://github.com/ipinfo/cli";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
