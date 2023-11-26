{ lib, buildNpmPackage, fetchzip }:

buildNpmPackage rec {
  pname = "github-copilot-cli";
  version = "0.1.33";

  src = fetchzip {
    url = "https://registry.npmjs.org/@githubnext/${pname}/-/${pname}-${version}.tgz";
    hash = "sha256-uTv6Z/AzvINinMiIfaaqRZDCmsAQ7tOE5SpuecpzGug=";
  };

  npmDepsHash = "sha256-VIg9a63GH246SbmK4Q8CwA2jdaaOwNUXoJkuDVwy5jE=";

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
  };
}

