{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "qovery-cli";
  version = "0.46.3";

  src = fetchFromGitHub {
    owner = "Qovery";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-DNwAsHznu+I8CItyvz4fG7QZDuQQvYPRYiy4qJbKZ3s=";
  };

  vendorSha256 = "sha256-4TY7/prMbvw5zVPJRoMLg7Omrxvh1HPGsdz1wqPn4uU=";

  meta = with lib; {
    description = "Qovery Command Line Interface";
    homepage = "https://github.com/Qovery/qovery-cli";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
