{ stdenv
, pkgs
, lib
, nodejs
, runtimeShell
}:

let
  nodePackages = import ./node-packages.nix {
    inherit pkgs nodejs;
    inherit (stdenv.hostPlatform) system;
  };

  nocodb = lib.head (lib.attrValues nodePackages);

  combined = nocodb.override {
    nativeBuildInputs = with pkgs.nodePackages; [
      node-pre-gyp
    ];
    postInstall = ''
      out_nocodb=$out/lib/node_modules/nocodb

      mkdir $out/bin
      cat <<EOF > $out/bin/nocodb
      #!${runtimeShell}
      exec ${nodejs}/bin/node $out_nocodb/server/server.js
      EOF
      chmod +x $out/bin/nocodb
    '';

    meta = with lib; {
      description = "Online collaborative whiteboard that is simple, free, easy to use and to deploy";
      license = licenses.agpl3Plus;
      homepage = "https://github.com/lovasoa/nocodb";
      maintainers = with maintainers; [ iblech ];
      platforms = platforms.unix;
    };
  };
in
  combined
