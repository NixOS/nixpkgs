{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "evans";
  version = "0.10.2";

  src = fetchFromGitHub {
    owner = "ktr0731";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-F9URMwQaSAQZaiZ95rDZqe8+YcJ9aMInSTIgQ7JLyOw=";
  };

  subPackages = [ "." ];

  vendorSha256 = "sha256-ICGnjI9sFwt81rZCnap/rggfSs4+pZNmLouoTY7CYKw=";

  meta = with lib; {
    description = "More expressive universal gRPC client";
    homepage = "https://evans.syfm.me/";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ diogox ];
  };
}
