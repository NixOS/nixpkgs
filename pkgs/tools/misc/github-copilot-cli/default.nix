{ lib, buildNpmPackage, fetchzip }:

buildNpmPackage rec {
  pname = "github-copilot-cli";
  version = "0.1.36";

  src = fetchzip {
    url = "https://registry.npmjs.org/@githubnext/${pname}/-/${pname}-${version}.tgz";
    hash = "sha256-7n+7sN61OrqMVGaKll85+HwX7iGG9M/UW5lf2Pd5sRU=";
  };

  npmDepsHash = "sha256-h0StxzGbl3ZeOQ4Jy1BgJ5sJ0pAbubMCRsiIOYpU04w=";

  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';

  dontNpmBuild = true;

  meta = with lib; {
    description = "A CLI experience for letting GitHub Copilot help you on the command line";
    homepage = "https://githubnext.com/projects/copilot-cli/";
    license = licenses.unfree; # upstream has no license
    maintainers = [ maintainers.malo ];
    platforms = platforms.all;
    mainProgram = "github-copilot-cli";
  };
}

