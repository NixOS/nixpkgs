{ lib
, nixosTests
, stdenv
, fetchFromGitHub
, makeWrapper
, nodejs
, pkgs
}:

stdenv.mkDerivation rec {
  pname = "haste-server";
  version = "72863858338a57d54eb9dee55530e90ebbc22453";

  src = fetchFromGitHub {
    owner = "toptal";
    repo = "haste-server";
    rev = version;
    hash = "sha256-MoEqpfihI3ZqSTHOxFbGziDv8khgq2Nd44YuKYDGflc=";
  };

  nativeBuildInputs = [
    nodejs
    makeWrapper
  ];

  installPhase =
    let
      nodeDependencies = ((import ./node-composition.nix {
        inherit pkgs nodejs;
        inherit (stdenv.hostPlatform) system;
      }).nodeDependencies.override (old: {
        # access to path '/nix/store/...-source' is forbidden in restricted mode
        src = src;
        dontNpmInstall = true;
      }));
    in
    ''
      runHook postInstall

      mkdir -p $out/share
      cp -ra . $out/share/haste-server
      ln -s ${nodeDependencies}/lib/node_modules $out/share/haste-server/node_modules
      makeWrapper ${nodejs}/bin/node $out/bin/haste-server \
        --add-flags $out/share/haste-server/server.js

      runHook postBuild
    '';

  passthru = {
    tests = {
      inherit (nixosTests) haste-server;
    };
    updateScript = ./update.sh;
  };

  meta = with lib; {
    description = "open source pastebin written in node.js";
    homepage = "https://www.toptal.com/developers/hastebin/about.md";
    license = licenses.mit;
    maintainers = with maintainers; [ mkg20001 ];
  };
}
