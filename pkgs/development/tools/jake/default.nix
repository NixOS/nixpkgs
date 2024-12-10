{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "jake";
  version = "10.8.7";

  src = fetchFromGitHub {
    owner = "jakejs";
    repo = "jake";
    rev = "v${version}";
    hash = "sha256-Qado9huQx9MVTFp8t7szB+IUVNWQqT/ni62JnURQqeM=";
  };

  npmDepsHash = "sha256-3pOFrH/em/HMTswrZLAeqPAb9U0/odcZPt4AkQkMhZM=";

  dontNpmBuild = true;

  meta = {
    description = "JavaScript build tool, similar to Make or Rake";
    homepage = "https://github.com/jakejs/jake";
    license = lib.licenses.asl20;
    mainProgram = "jake";
    maintainers = with lib.maintainers; [ jasoncarr ];
  };
}
