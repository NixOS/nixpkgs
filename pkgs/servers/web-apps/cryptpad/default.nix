{ stdenv
, pkgs
, lib
, buildBowerComponents
, fetchbower
, fetchurl
, nodejs
}:

let
  nodePackages = import ./node-packages.nix {
    inherit pkgs nodejs;
    inherit (stdenv.hostPlatform) system;
  };

  bowerPackages = (buildBowerComponents {
    name = "${cryptpad.name}-bower-packages";
    generated = ./bower-packages.nix;
    src = cryptpad.src;
  }).overrideAttrs (old: {
    bowerPackages = old.bowerPackages.override (old_: {
      # add missing dependencies:
      # Those dependencies are EOL and they are not installed by buildBowerComponents,
      # but they are required, otherwise the resolver crashes.
      # * add the second jquery ~2.1.0 entry
      # * add the second bootstrap ~3.1.1 entry
      paths = old_.paths ++ [
        (fetchbower "jquery" "2.1.0" "~2.1.0" "02kwvz93vzpv10qnp7s0dz3al0jh77awwrizb6wadsvgifxssnlr")
        (fetchbower "bootstrap" "3.1.1" "~3.1.1" "06bhjwa8p7mzbpr3jkgydd804z1nwrkdql66h7jkfml99psv9811")
      ];
    });
  });

  # find an element in an attribute set
  findValue = pred: default: set:
    let
      list =
        lib.concatMap
          (name:
            let v = set.${name}; in
            if pred name v then [ v ] else [ ]
          )
          (lib.attrNames set)
      ;
    in
    if list == [ ] then default
    else lib.head list
  ;

  # The cryptpad package attribute key changes for each release. Get it out
  # programatically instead.
  cryptpad = findValue
    (k: v: v.packageName == "cryptpad")
    (throw "cryptpad not found")
    nodePackages
  ;

  combined = cryptpad.override {
    postInstall = ''
      out_cryptpad=$out/lib/node_modules/cryptpad

      substituteInPlace $out_cryptpad/lib/workers/index.js --replace "lib/workers/db-worker" "$out_cryptpad/lib/workers/db-worker"

      # add the bower components
      ln -sv \
        ${bowerPackages}/bower_components \
        $out_cryptpad/www/bower_components

      # add executable
      mkdir $out/bin
      cat <<EOF > $out/bin/cryptpad
      #!${stdenv.shell}
      exec ${nodejs}/bin/node $out_cryptpad/server.js
      EOF
      chmod +x $out/bin/cryptpad
    '';

    meta = {
      longDescription = ''
        CryptPad is a collaboration suite that is end-to-end-encrypted and open-source.
        It is built to enable collaboration, synchronizing changes to documents in real time.
        Because all data is encrypted, the service and its administrators have no way of seeing the content being edited and stored.
      '';
      maintainers = with lib.maintainers; [ davhau ];
      mainProgram = "cryptpad";
    };

  };
in
combined
