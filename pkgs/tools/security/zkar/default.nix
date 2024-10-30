{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "zkar";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "phith0n";
    repo = "zkar";
    rev = "refs/tags/v${version}";
    hash = "sha256-F4bGGOZ6ftaSDbsPh3ML9qJoXmdSD6TGc7mt4HOuPkU=";
  };

  vendorHash = "sha256-Eyi22d6RkIsg6S5pHXOqn6kULQ/mLeoaxSxxJJkMgIQ=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Java serialization protocol analysis tool";
    homepage = "https://github.com/phith0n/zkar";
    changelog = "https://github.com/phith0n/zkar/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
    mainProgram = "zkar";
  };
}
