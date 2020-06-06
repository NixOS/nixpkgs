{ buildGoModule
, lib
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "go-tools";
  version = "2020.1.4";

  src = fetchFromGitHub {
    owner = "dominikh";
    repo = "go-tools";
    rev = version;
    sha256 = "182j3zzx1bj4j4jiamqn49v9nd3vcrx727f7i9zgcrgmiscvw3mh";
  };

  vendorSha256 = "0nbbngsphklzhcmqafrw1im2l1vnfcma9sb4vskdpdrsadv5ss5r";

  meta = with lib; {
    description = "A collection of tools and libraries for working with Go code, including linters and static analysis";
    homepage = "https://staticcheck.io";
    license = licenses.mit;
    maintainers = with maintainers; [ rvolosatovs kalbasit ];
  };
}