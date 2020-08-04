{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "ctop";
  version = "0.7.3";

  src = fetchFromGitHub {
    owner = "bcicen";
    repo = pname;
    rev = "v${version}";
    sha256 = "0y72l65xgfqrgghzbm1zcy776l5m31z0gn6vfr689zyi3k3f4kh8";
  };

  vendorSha256 = "1x4li44vg0l1x205v9a971cgphplxhsrn59q97gmj9cfy4m7jdfw";

  buildFlagsArray = [ "-ldflags=-s -w -X main.version=${version} -X main.build=v${version}" ];

  meta = with lib; {
    description = "Top-like interface for container metrics";
    homepage = "https://ctop.sh/";
    license = licenses.mit;
    maintainers = with maintainers; [ apeyroux marsam ];
  };
}
