{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "mubeng";
  version = "0.14.2";

  src = fetchFromGitHub {
    owner = "kitabisa";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-MdTgYhHjgDFplh+wcb9QTwzwMZSmF2kqMmu1x8WmOyQ=";
  };

  vendorHash = "sha256-kOLeaEKtpI3l0qLphRTnm27Ms63ID4LJ6VkUHJzGAcc=";

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
    mainProgram = "mubeng";
  };
}
