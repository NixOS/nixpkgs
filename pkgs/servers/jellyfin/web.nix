{ lib
, fetchFromGitHub
, pkgs
, stdenv
, nodejs
}:

stdenv.mkDerivation rec {
  pname = "jellyfin-web";
  version = "10.8.7";

  src = fetchFromGitHub {
    owner = "jellyfin";
    repo = "jellyfin-web";
    rev = "v${version}";
    sha256 = "8WHXgNB7yay/LgKZWNKuPo30vbS7SEM9s+EPUMyhN/g=";
  };

  nativeBuildInputs = [
    nodejs
  ];

  buildPhase =
    let
      nodeDependencies = ((import ./node-composition.nix {
        inherit pkgs nodejs;
        inherit (stdenv.hostPlatform) system;
      }).nodeDependencies.override (old: {
        # access to path '/nix/store/...-source' is forbidden in restricted mode
        src = src;

        # dont run the prepare script:
        # Error: Cannot find module '/nix/store/...-node-dependencies-jellyfin-web-.../jellyfin-web/scripts/prepare.js
        # npm run build:production runs the same command
        dontNpmInstall = true;
      }));
    in
    ''
      runHook preBuild

      ln -s ${nodeDependencies}/lib/node_modules ./node_modules
      export PATH="${nodeDependencies}/bin:$PATH"

      npm run build:production

      runHook postBuild
    '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share
    cp -a dist $out/share/jellyfin-web

    runHook postInstall
  '';

  passthru.updateScript = ./web-update.sh;

  meta = with lib; {
    description = "Web Client for Jellyfin";
    homepage = "https://jellyfin.org/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ nyanloutre minijackson purcell jojosch ];
    platforms = nodejs.meta.platforms;
  };
}
