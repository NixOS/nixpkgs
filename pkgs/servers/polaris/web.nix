{ lib
, stdenv
, pkgs
, fetchFromGitHub
, nodejs
, cypress
}:

stdenv.mkDerivation rec {
  pname = "polaris-web";
  version = "build-55";

  src = fetchFromGitHub {
    owner = "agersant";
    repo = "polaris-web";
    rev = "${version}";
    sha256 = "2XqU4sExF7Or7RxpOK2XU9APtBujfPhM/VkOLKVDvF4=";
  };

  nativeBuildInputs = [
    nodejs
  ];

  buildPhase =
    let
      nodeDependencies = (import ./node-composition.nix {
        inherit pkgs nodejs;
        inherit (stdenv.hostPlatform) system;
      }).nodeDependencies.override (old: {
        # access to path '/nix/store/...-source' is forbidden in restricted mode
        src = src;
        dontNpmInstall = true;

        # ERROR: .../.bin/node-gyp-build: /usr/bin/env: bad interpreter: No such file or directory
        # https://github.com/svanderburg/node2nix/issues/275
        # There are multiple instances of it, hence the globstar
        preRebuild = ''
          shopt -s globstar
          sed -i -e "s|#!/usr/bin/env node|#! ${pkgs.nodejs}/bin/node|" \
            node_modules/**/node-gyp-build/bin.js \
        '';

        buildInputs = [ cypress ];
        # prevent downloading cypress, use the executable in path instead
        CYPRESS_INSTALL_BINARY = "0";

      });
    in
    ''
      runHook preBuild

      export PATH="${nodeDependencies}/bin:${nodejs}/bin:$PATH"

      # https://github.com/parcel-bundler/parcel/issues/8005
      export NODE_OPTIONS=--no-experimental-fetch

      ln -s ${nodeDependencies}/lib/node_modules .
      npm run production

      runHook postBuild
    '';


  installPhase = ''
    runHook preInstall

    mkdir -p $out/share
    cp -a dist $out/share/polaris-web

    runHook postInstall
  '';

  passthru.updateScript = ./update-web.sh;

  meta = with lib; {
    description = "Web client for Polaris";
    homepage = "https://github.com/agersant/polaris-web";
    license = licenses.mit;
    maintainers = with maintainers; [ pbsds ];
    platforms = platforms.unix;
  };
}
