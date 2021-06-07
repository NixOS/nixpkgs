{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "evans";
  version = "0.9.3";

  src = fetchFromGitHub {
    owner = "ktr0731";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-q8HWDZpUWaitdZcWkvKEWWbIWCj9VmWCxxhAdcYZx8s=";
  };

  subPackages = [ "." ];

  vendorSha256 = "sha256-ntRlrbsQjZmVxEg9361Q+f6Wb/R393+sbOKOEh5VKPk=";

  meta = with lib; {
    description = "More expressive universal gRPC client";
    homepage = "https://evans.syfm.me/";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ diogox ];
  };
}
