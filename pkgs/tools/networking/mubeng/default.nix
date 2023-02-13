{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "mubeng";
  version = "0.13.2";

  src = fetchFromGitHub {
    owner = "kitabisa";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-EIglOoHL1ZmkFUn2MTU+ISQmaX96kCxelwk5ylHlMHk=";
  };

  vendorHash = "sha256-1RJAmz3Tw6c2Y7lXlXvq/aEkVLO+smkwuNJbi7aBUNo=";

  ldflags = [
    "-s"
    "-w"
    "-X ktbs.dev/mubeng/common.Version=${version}"
  ];

  meta = with lib; {
    description = "Proxy checker and IP rotator";
    homepage = "https://github.com/kitabisa/mubeng";
    changelog = "https://github.com/kitabisa/mubeng/releases/tag/v${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
