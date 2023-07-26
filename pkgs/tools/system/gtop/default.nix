{ lib
, buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage rec {
  pname = "gtop";
  version = "1.1.3";

  src = fetchFromGitHub {
    owner = "aksakalli";
    repo = "gtop";
    rev = "v${version}";
    hash = "sha256-7jcfJOdy3PKT6+07iaZnjWnlPLk9BhPn8LApk23E8l4=";
  };

  npmDepsHash = "sha256-CUfoVkG74C7HpcO3T9HmwbxHsYAgW1vYBAgNvx2av0k=";

  dontNpmBuild = true;

  meta = {
    description = "System monitoring dashboard for the terminal";
    homepage = "https://github.com/aksakalli/gtop";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tfc ];
  };
}
