{ lib
, buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage rec {
  pname = "commit-and-tag-version";
  version = "11.2.2";

  src = fetchFromGitHub {
    owner = "absolute-version";
    repo = "commit-and-tag-version";
    rev = "v${version}";
    hash = "sha256-1oX0zijmGj+dQO+18bU/Oi4NVOf8Z652Sj2LJS8CxxY=";
  };

  npmDepsHash = "sha256-JNJATd8P98YKS5rHhmZgpewm8PPyZLKUtXSWZR6gLOY=";

  dontNpmBuild = true;

  meta = with lib; {
    description = "A utility for versioning using semver and CHANGELOG generation powered by Conventional Commits";
    homepage = "https://github.com/absolute-version/commit-and-tag-version";
    license = licenses.isc;
    maintainers = with maintainers; [ DCsunset ];
  };
}
