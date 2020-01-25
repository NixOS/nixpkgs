{ fetchgit, runCommand, jq }: let
  src = fetchgit {
    url = "https://github.com/tootsuite/mastodon.git";
    rev = "v3.0.1";
    sha256 = "11vljzarhgs6hik6qhimlaimqm5ysljf9jm402r5fpy6axh6yksc";
  };
  version = import ./version.nix;
in runCommand "mastodon-source" { buildInputs = [ jq ]; } ''
  cp -r ${src} $out
  chmod -R u+w $out
  if [ $(jq .version ${src}/package.json) == "null" ]; then
    jq ". + {version: \"${version}\"}" ${src}/package.json > $out/package.json
  fi
''
