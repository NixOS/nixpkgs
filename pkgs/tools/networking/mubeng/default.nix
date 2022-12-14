{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "mubeng";
  version = "0.12.0-dev";

  src = fetchFromGitHub {
    owner = "kitabisa";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-NBZmu0VcVUhJSdM3fzZ+4Q5oX8uxO6GLpEUq74x8HUU=";
  };

  vendorSha256 = "sha256-1JxyP6CrJ4/g7o3eGeN1kRXJU/jNLEB8fW1bjJytQqQ=";

  ldflags = [ "-s" "-w" "-X ktbs.dev/mubeng/common.Version=${version}" ];

  meta = with lib; {
    description = "Proxy checker and IP rotator";
    homepage = "https://github.com/kitabisa/mubeng";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
