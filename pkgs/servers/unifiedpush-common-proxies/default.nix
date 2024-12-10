{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "unifiedpush-common-proxies";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "unifiedpush";
    repo = "common-proxies";
    rev = "v${version}";
    sha256 = "sha256-eonKHhaH7mAdW7ouprQivMxKPGFv0s1m/S8jGwid8kM=";
  };

  vendorHash = "sha256-s0uN6PzIaAHLvRb9T07Xvb6mMAuvKHQ4oFJtl5hsvY4=";

  meta = with lib; {
    description = "A set of rewrite proxies and gateways for UnifiedPush";
    homepage = "https://github.com/UnifiedPush/common-proxies";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    mainProgram = "up_rewrite";
  };
}
