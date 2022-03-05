{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "safe";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "starkandwayne";
    repo = "safe";
    rev = "v${version}";
    sha256 = "sha256-ankX4BeMvBEd0e01mQHfaPg4z1z+IZqELaSEJ5deF8Y=";
  };

  vendorSha256 = "sha256-7hX35FfFxfoiI/dSxWhZH8iJoRWa4slAJF0lULq8KL4=";

  subPackages = [ "." ];

  ldflags = [
    "-X main.Version=${version}"
  ];

  meta = with lib; {
    description = "A Vault CLI";
    homepage = "https://github.com/starkandwayne/safe";
    license = licenses.mit;
    maintainers = with maintainers; [ eonpatapon ];
  };
}
