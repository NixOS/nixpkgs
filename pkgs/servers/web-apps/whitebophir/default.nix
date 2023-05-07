{ stdenv
, pkgs
, lib
, nodejs_16
, runtimeShell
}:

let
  nodejs = nodejs_16;

  nodePackages = import ./node-packages.nix {
    inherit pkgs nodejs;
    inherit (stdenv.hostPlatform) system;
  };

  whitebophir = lib.head (lib.attrValues nodePackages);

  combined = whitebophir.override {
    postInstall = ''
      out_whitebophir=$out/lib/node_modules/whitebophir

      mkdir $out/bin
      cat <<EOF > $out/bin/whitebophir
      #!${runtimeShell}
      exec ${nodejs}/bin/node $out_whitebophir/server/server.js
      EOF
      chmod +x $out/bin/whitebophir
    '';

    meta = with lib; {
      description = "Online collaborative whiteboard that is simple, free, easy to use and to deploy";
      license = licenses.agpl3Plus;
      homepage = "https://github.com/lovasoa/whitebophir";
      maintainers = with maintainers; [ iblech ];
      platforms = platforms.unix;
    };
  };
in
  combined
