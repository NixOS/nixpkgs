{ lib
, fetchFromGitHub
, buildGoModule
}:

buildGoModule rec {
  pname = "unifiedpush-common-proxies";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "unifiedpush";
    repo = "common-proxies";
    rev = "v${version}";
    sha256 = "sha256-pMzKK18FZCqJ86nqXfOT7tKCqIw6P0ioxRUi72aef0A=";
  };

  vendorHash = "sha256-wVZR/h0AtwZ1eo7EoRKNzaS2Wp0X01e2u3Ugmsnj644=";

  meta = with lib; {
    description = "Set of rewrite proxies and gateways for UnifiedPush";
    homepage = "https://github.com/UnifiedPush/common-proxies";
    license = licenses.mit;
    maintainers = [ ];
    mainProgram = "up_rewrite";
  };
}
