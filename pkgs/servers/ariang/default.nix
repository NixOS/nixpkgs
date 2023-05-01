{ lib
, stdenv
, pkgs
, fetchFromGitHub
, nodejs ? pkgs.nodejs_14
}:

stdenv.mkDerivation rec {
  pname = "ariang";
  version = "1.3.3";

  src = fetchFromGitHub {
    owner = "mayswind";
    repo = "AriaNg";
    rev = version;
    hash = "sha256-kh2XdsrZhR0i+vUhTrzXu5z5Ahv9otNEEjqlCUnVmqE=";
  };

  buildPhase =
    let
      nodePackages = import ./node-composition.nix {
        inherit pkgs nodejs;
        inherit (stdenv.hostPlatform) system;
      };
      nodeDependencies = (nodePackages.shell.override (old: {
        # access to path '/nix/store/...-source' is forbidden in restricted mode
        src = src;
        # Error: Cannot find module '/nix/store/...-node-dependencies
        dontNpmInstall = true;
      })).nodeDependencies;
    in
    ''
      runHook preBuild

      ln -s ${nodeDependencies}/lib/node_modules ./node_modules
      ${nodeDependencies}/bin/gulp clean build

      runHook postBuild
    '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share
    cp -r dist $out/share/ariang

    runHook postInstall
  '';

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "a modern web frontend making aria2 easier to use";
    homepage = "http://ariang.mayswind.net/";
    license = licenses.mit;
    maintainers = with maintainers; [ stunkymonkey ];
    platforms = platforms.unix;
  };
}


