{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "aws-nuke";
  version = "2.23.0";

  src = fetchFromGitHub {
    owner = "rebuy-de";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-fvEUZWnYjSZrdTLTq1WVuZ3GaIWqdk3+qnuXDwT0K/0=";
  };

  vendorHash = "sha256-c9OpKsP4TQ4aDZnHPSy6tNmNBN6tsj4Kb8WOig5+ogI=";

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
