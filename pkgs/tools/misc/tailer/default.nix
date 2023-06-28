{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule {
  pname = "tailer";
  version = "unstable-2023-06-26";

  src = fetchFromGitHub {
    owner = "hionay";
    repo = "tailer";
    rev = "2f32e2640a220c990ae419d1562889971c9ed535";
    hash = "sha256-L+5HlUv6g2o6ghqp8URfR7k5NlWqFhVBmEIsEjGy7aU=";
  };

  vendorHash = "sha256-nQqSvfN+ed/g5VkbD6XhZNA1G3CGGfwFDdadJ5+WoD0=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "A CLI tool to insert lines when command output stops";
    homepage = "https://github.com/hionay/tailer";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
