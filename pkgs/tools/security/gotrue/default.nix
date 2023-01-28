{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gotrue";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "netlify";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-9h6CyCY7741tJR+qWDLwgPkAtE/kmaoTqlXEY+mOW58=";
  };

  vendorHash = "sha256-x96+l9EBzYplGRFHsfQazSjqZs35bdXQEJv3pBuaJVo=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/netlify/gotrue/cmd.Version=${version}"
  ];

  # integration tests require network access
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/netlify/gotrue";
    description = "An SWT based API for managing users and issuing SWT tokens";
    changelog = "https://github.com/netlify/gotrue/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ urandom ];
  };
}
