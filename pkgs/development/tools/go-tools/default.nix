{ buildGoModule
, lib
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "go-tools";
  version = "2020.1.5";

  src = fetchFromGitHub {
    owner = "dominikh";
    repo = "go-tools";
    rev = version;
    sha256 = "1ry3ywncc9qkmh8ihh67v6k8nmqhq2gvfyrl1ykl4z6s56b7f9za";
  };

  vendorSha256 = "0nbbngsphklzhcmqafrw1im2l1vnfcma9sb4vskdpdrsadv5ss5r";

  meta = with lib; {
    description = "A collection of tools and libraries for working with Go code, including linters and static analysis";
    homepage = "https://staticcheck.io";
    license = licenses.mit;
    maintainers = with maintainers; [ rvolosatovs kalbasit ];
  };
}
