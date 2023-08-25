{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "aws-nuke";
  version = "2.24.1";

  src = fetchFromGitHub {
    owner = "rebuy-de";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-AftmWmZFi9NIXNxbMEO1eIzRl3UwS3rxXZ4htJClEfo=";
  };

  vendorHash = "sha256-cYQlHl0fmLH5f+QNdJ+V6L9Ts8sa9y8l0oOIqdpJlL0=";

  overrideModAttrs = _: {
    preBuild = ''
      go generate ./...
    '';
  };

  doCheck = false;

  subPackages = [ "." ];

  meta = with lib; {
    description = "Nuke a whole AWS account and delete all its resources";
    homepage = "https://github.com/rebuy-de/aws-nuke";
    license = licenses.mit;
    maintainers = with maintainers; [ grahamc ];
  };
}
