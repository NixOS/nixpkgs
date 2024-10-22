{
  lib,
  stdenv,
  fetchFromGitHub,
  pnpm,
  makeWrapper,
  node-pre-gyp,
  nodejs,
  python3,
  sqlite,
}:

stdenv.mkDerivation (finalAttrs: rec {
  pname = "";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "Fallenbagel";
    repo = "";
    rev = "v${version}";
    hash = "sha256-ZqHm8GeougFGfOeHXit2+2dRMeQrGgt3kFlm7pUxWpg=";
  };

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs) pname version src;
    hash = "";
  };

  nativeBuildInputs = [
    nodejs
    makeWrapper
    pnpm.configHook
  ];

  buildInputs = [
    node-pre-gyp
    python3
    sqlite
  ];

  buildPhase = ''
    runHook preBuild
    pnpm build
    pnpm --ignore-scripts prune --prod
    runHook postBuild
  '';

  postBuild = ''
    export CPPFLAGS="-I${nodejs}/include/node"
    pushd node_modules/sqlite3
    node-pre-gyp install --prefer-offline --build-from-source --nodedir=${nodejs}/include/node --sqlite=${sqlite.dev}
    rm -r build-tmp-napi-v6
    popd
    pushd node_modules/bcrypt
    node-pre-gyp install --prefer-offline --build-from-source --nodedir=${nodejs}/include/node
    popd
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/{bin,libexec}
    cp -r {.next,config,dist,node_modules,overseerr-api.yml,package.json} $out/libexec
    runHook postInstall
  '';

  postInstall = ''
    makeWrapper '${nodejs}/bin/node' "$out/bin/jellyseerr" \
      --add-flags "$out/libexec/dist/index.js" \
      --set NODE_ENV production
  '';

  doDist = false;

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "Fork of overseerr for jellyfin support";
    homepage = "https://github.com/Fallenbagel/jellyseerr";
    longDescription = ''
      Jellyseerr is a free and open source software application for managing
      requests for your media library. It is a fork of Overseerr built to
      bring support for Jellyfin & Emby media servers!
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ camillemndn ];
    platforms = platforms.linux;
    mainProgram = "";
  };
})
