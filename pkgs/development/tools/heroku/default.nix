{ stdenv, lib, fetchzip, makeWrapper, nodejs }:

let
  # version and commit pairs can be found in the URLs at
  # https://cli-assets.heroku.com/versions/heroku-linux-x64-tar-xz.json
  version = "8.7.1";
  commit = "3f5e369";
  hash = "sha256-3pCutQBS8N1Yw4JKTvU046UrOxBi0wLRQywxwezAEeU";
in
stdenv.mkDerivation {
  pname = "heroku";
  inherit version;

  src = fetchzip {
    url = "https://cli-assets.heroku.com/versions/${version}/${commit}/heroku-v${version}-${commit}-linux-x64.tar.xz";
    inherit hash;
  };

  nativeBuildInputs = [ makeWrapper ];

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/share/heroku $out/bin
    cp -pr * $out/share/heroku
    substituteInPlace $out/share/heroku/bin/run \
      --replace "/usr/bin/env node" "${nodejs}/bin/node"
    makeWrapper $out/share/heroku/bin/run $out/bin/heroku \
      --set HEROKU_DISABLE_AUTOUPDATE 1
  '';

  meta = {
    homepage = "https://devcenter.heroku.com/articles/heroku-cli";
    description = "Everything you need to get started using Heroku";
    maintainers = with lib.maintainers; [ aflatter mirdhyn marsam ];
    license = lib.licenses.mit;
    platforms = with lib.platforms; unix;
  };
}
