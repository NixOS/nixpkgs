{ buildNpmPackage
, fetchFromGitHub
, lib
}:

buildNpmPackage rec {
  pname = "sharing";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "parvardegr";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-y5tAbyRGxr6lagU/+pLBN0VIpk3+SzKyXOehQk6NW+M=";
  };

  npmDepsHash = "sha256-2DwFkkoODDuLOxF63F1ywoXzjcMn/+H2ycRWlJlNcCI=";

  dontNpmBuild = true;

  # The prepack script runs the build script, which we'd rather do in the build phase.
  npmPackFlags = [ "--ignore-scripts" ];

  NODE_OPTIONS = "--openssl-legacy-provider";

  meta = with lib; {
    description = "Command-line tool to share directories and files to mobile devices";
    homepage = "https://github.com/parvardegr/sharing";
    license = licenses.mit;
    maintainers = with maintainers; [ ChaosAttractor ];
  };
}
