{ lib
, buildNpmPackage
, fetchFromGitHub
}:

let
  version = "0.6.3";
  src = fetchFromGitHub {
    owner = "bscan";
    repo = "PerlNavigator";
    rev = "v${version}";
    hash = "sha256-CNsgFf+W7YQwAR++GwfTka4Cy8woRu02BQIJRmRAxK4=";
  };
  browser-ext = buildNpmPackage {
    pname = "perlnavigator-web-server";
    inherit version src;
    sourceRoot = "${src.name}/browser-ext";
    npmDepsHash = "sha256-PJKW+ni2wKw1ivkgQsL6g0jaxoYboa3XpVEEwgT4jWo=";
    dontNpmBuild = true;
    installPhase = ''
      cp -r . "$out"
    '';
  };
  client = buildNpmPackage {
    pname = "perlnavigator-client";
    inherit version src;
    sourceRoot = "${src.name}/client";
    npmDepsHash = "sha256-CM0l+D1VNkXBrZQHQGDiB/vAxMvpbHYoYlIugoLxSfA=";
    dontNpmBuild = true;
    installPhase = ''
      cp -r . "$out"
    '';
  };
  server = buildNpmPackage {
    pname = "perlnavigator-server";
    inherit version src;
    sourceRoot = "${src.name}/server";
    npmDepsHash = "sha256-TxK3ba9T97p8TBlULHUov6YX7WRl2QMq6TiNHxBoQeY=";
    dontNpmBuild = true;
    installPhase = ''
      cp -r . "$out"
    '';
  };
in buildNpmPackage rec {
  pname = "perlnavigator";
  inherit version src;

  npmDepsHash = "sha256-nEinmgrbbFC+nkfTwu9djiUS+tj0VM4WKl2oqKpcGtM=";

  postPatch = ''
    sed -i /postinstall/d package.json

    rm -r browser-ext client server
    cp -r ${browser-ext} browser-ext
    cp -r ${client} client
    cp -r ${server} server
    chmod +w browser-ext client server
  '';

  env = {
    PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD = 1;
  };

  npmBuildScript = "compile";

  postInstall = ''
    cp -r ${browser-ext}/node_modules "$out/lib/node_modules/perlnavigator/browser-ext"
    cp -r ${client}/node_modules "$out/lib/node_modules/perlnavigator/client"
    cp -r ${server}/node_modules "$out/lib/node_modules/perlnavigator/server"
  '';

  meta = {
    changelog = "https://github.com/bscan/PerlNavigator/blob/${src.rev}/CHANGELOG.md";
    description = "Perl Language Server that includes syntax checking, perl critic, and code navigation";
    homepage = "https://github.com/bscan/PerlNavigator/tree/main/server";
    license = lib.licenses.mit;
    mainProgram = "perlnavigator";
    maintainers = with lib.maintainers; [ wolfangaukang ];
  };
}
