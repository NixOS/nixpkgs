{ lib
, fetchFromGitHub
, buildGoModule
}:

buildGoModule rec {
  pname = "unifiedpush-common-proxies";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "unifiedpush";
    repo = "common-proxies";
    rev = "v${version}";
    sha256 = "sha256-spOLgSqiEySVc7imeTeg83MO5cw5nea0qD6OV8JRI6Y=";
  };

  vendorSha256 = "13mxdjc9fvajl0w78a5g1cqadgmxsx74zz8npp5h2s68zkl8sjxk";

  meta = with lib; {
    description = "A set of rewrite proxies and gateways for UnifiedPush";
    homepage = "https://github.com/UnifiedPush/common-proxies";
    license = licenses.mit;
    maintainers = with maintainers; [ yuka ];
    mainProgram = "up_rewrite";
  };
}
