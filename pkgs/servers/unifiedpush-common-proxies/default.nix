{ lib
, fetchFromGitHub
, buildGoModule
}:

buildGoModule rec {
  pname = "unifiedpush-common-proxies";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "unifiedpush";
    repo = "common-proxies";
    rev = "v${version}";
    sha256 = "0wf6kmj8m2c06864qiphf91j5rpaj3bvjrafdk6lqli14p5gmma2";
  };

  vendorSha256 = "13mxdjc9fvajl0w78a5g1cqadgmxsx74zz8npp5h2s68zkl8sjxk";

  meta = with lib; {
    description = "A set of rewrite proxies and gateways for UnifiedPush";
    homepage = "https://github.com/UnifiedPush/common-proxies";
    license = licenses.mit;
    maintainers = with maintainers; [ yuka ];
  };
}
