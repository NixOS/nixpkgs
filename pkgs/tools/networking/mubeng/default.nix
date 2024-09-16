{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "mubeng";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "kitabisa";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-xfoYUcnCwrJ3SM+Xr+dsf4NnisN5K4UehT9T2US5p/s=";
  };

  vendorHash = "sha256-TZDQCvcwsCa08bBBb8Zs8W0OFDYb+ZWN85+VCelFgyc=";

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
