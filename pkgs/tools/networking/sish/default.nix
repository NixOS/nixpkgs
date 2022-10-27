{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "sish";
  version = "2.8.1";

  src = fetchFromGitHub {
    owner = "antoniomika";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-BzWpEkhLhTNt5C/1G0Hnkli2kMvRwGbRc1bCgsWdRUo=";
  };

  vendorSha256 = "sha256-SQKkhyUYuOuPb8SOtjgRTsGKg6T75Zcot5ufHSUaiCM=";

  meta = with lib; {
    description = "HTTP(S)/WS(S)/TCP Tunnels to localhost";
    homepage = "https://github.com/antoniomika/sish";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
