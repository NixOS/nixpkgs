{ pkgs, nodejs, stdenv, lib, ... }:

let

  packageName = with lib; concatStrings (map (entry: (concatStrings (mapAttrsToList (key: value: "${key}-${value}") entry))) (importJSON ./package.json));

  nodePackages = import ./node-composition.nix {
    inherit pkgs nodejs;
    inherit (stdenv.hostPlatform) system;
  };
in
nodePackages."${packageName}".override {
  postInstall = ''
    npm run build
    cp -v dist/*.js $out/
    rm -rf $out/lib
  '';

  meta = with lib; {
    description = "Minimalistic graph card for Home Assistant Lovelace UI";
    homepage = "https://github.com/kalkih/mini-graph-card";
    maintainers = with maintainers; [ hexa ];
    license = licenses.mit;
  };
}

