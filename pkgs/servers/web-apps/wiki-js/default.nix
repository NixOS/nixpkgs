{ stdenv, fetchurl, lib, nixosTests, jq, moreutils }:

stdenv.mkDerivation rec {
  pname = "wiki-js";
  version = "2.5.299";

  src = fetchurl {
    url = "https://github.com/Requarks/wiki/releases/download/v${version}/${pname}.tar.gz";
    sha256 = "sha256-GYe05dbR8RwCzPedeCMUQTWZ51roM/V2jUPPv7o7UEU=";
  };

  # Implements nodejs 18 support as it's not planned to fix this before
  # the release of v3[1] which is planned to happen in 2023, but not before
  # NixOS 23.05. However, in the lifespan of 23.05 v16 will get EOLed, so
  # we have to hack this on our own.
  #
  # The problem we fix here is that `exports."/public/"` in a `package.json`
  # is prohibited, i.e. you cannot export full directories anymore.
  #
  # Unfortunately it's non-trivial to fix this because v10 of `extract-files`
  # (where the problem is fixed) doesn't work for graphql-tools (which depends
  # on this). Updating this as well is also quite complex because in later
  # versions the package was split up into multiple smaller packages and
  # thus a lot of parts of the code-base would need to be changed accordingly.
  #
  # Since this is the only breaking change of nodejs 17/18[2][3], this workaround
  # will be necessary until we can upgrade to v3.
  #
  # [1] https://github.com/requarks/wiki/discussions/6388
  # [2] https://nodejs.org/en/blog/release/v17.0.0
  # [3] https://nodejs.org/en/blog/release/v18.0.0
  patches = [ ./drop-node-check.patch ];
  nativeBuildInputs = [ jq moreutils ];
  postPatch = ''
    # Dirty hack to implement nodejs-18 support.
    <./node_modules/extract-files/package.json jq '
      # error out loud if the structure has changed and we need to change
      # this expression
      if .exports|has("./public/")|not then
        halt_error(1)
      else
        .exports."./public/*" = "./public/*.js" | del(.exports."./public/")
      end
    ' | sponge ./node_modules/extract-files/package.json
  '';

  sourceRoot = ".";

  dontBuild = true;
  installPhase = ''
    runHook preInstall

    mkdir $out
    cp -r . $out

    runHook postInstall
  '';

  passthru = {
    tests = { inherit (nixosTests) wiki-js; };
    updateScript = ./update.sh;
  };

  meta = with lib; {
    homepage = "https://js.wiki/";
    description = "A modern and powerful wiki app built on Node.js";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ ma27 ];
  };
}
