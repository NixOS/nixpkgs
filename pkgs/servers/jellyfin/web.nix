{ lib
, fetchFromGitHub
, pkgs
, stdenv
, nodejs
}:

stdenv.mkDerivation rec {
  pname = "jellyfin-web";
  version = "10.7.7";
  # TODO: on the next major release remove src.postFetch
  # and use the lock file in web-update.sh:
  # https://github.com/jellyfin/jellyfin-web/commit/6efef9680d55a93f4333ef8bfb65a8a650c99a49

  src = fetchFromGitHub {
    owner = "jellyfin";
    repo = "jellyfin-web";
    rev = "v${version}";
    sha256 = "RDp51IWQ0Woz26cVgWsiLc8DyZztI2ysPbhmOR3jguE=";
    postFetch = ''
      mkdir -p $out
      cd $out
      tar -xzf $downloadedFile --strip-components=1

      # replace unsupported dependency url
      # https://github.com/svanderburg/node2nix/issues/163
      substituteInPlace package.json \
        --replace \
          "https://github.com/jellyfin/JavascriptSubtitlesOctopus#4.0.0-jf-smarttv" \
          "https://github.com/jellyfin/JavascriptSubtitlesOctopus/archive/refs/tags/4.0.0-jf-smarttv.tar.gz"
    '';
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
  };
}
