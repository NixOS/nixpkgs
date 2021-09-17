{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "ipinfo";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = pname;
    repo = "cli";
    rev = "${pname}-${version}";
    sha256 = "15pwx94n4qi02r3ppqkpnkikpnbqmr8rrn9gmkbjy2vbdi147qwl";
  };

  vendorSha256 = null;

  # Tests require network access
  doCheck = false;

  meta = with lib; {
    description = "Command Line Interface for the IPinfo API";
    homepage = "https://github.com/ipinfo/cli";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
