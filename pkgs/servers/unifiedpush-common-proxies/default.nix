{ lib
, fetchFromGitHub
, buildGoModule
}:

buildGoModule rec {
  pname = "unifiedpush-common-proxies";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "unifiedpush";
    repo = "common-proxies";
    rev = "v${version}";
    sha256 = "sha256-1Nl36Ldb0/DrQEKgPBsCgJk7oRCIq2m9Vb8D8wnS1g0=";
  };

  vendorSha256 = "sha256-7A2ErjqmgberMabayWEc3w53+YierfetzmT8DzHwbpE=";

  meta = with lib; {
    description = "A set of rewrite proxies and gateways for UnifiedPush";
    homepage = "https://github.com/UnifiedPush/common-proxies";
    license = licenses.mit;
    maintainers = with maintainers; [ yuka ];
  };
}
