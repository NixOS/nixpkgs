{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "aws-nuke";
  version = "2.24.2";

  src = fetchFromGitHub {
    owner = "rebuy-de";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Zy+ULmGDUK4KGMJ5PXTyT8CSp0nC71AW/4Udl2ElOCg=";
  };

  vendorHash = "sha256-srQuR9ZoTjZR1XfewFv7wF188Q5FggMdicm71v6MY/8=";

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
