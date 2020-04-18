{ stdenv
, pkgs
, lib
, buildBowerComponents
, fetchurl
, nodejs
}:

let
  nodePackages = import ./node-packages.nix {
    inherit pkgs nodejs;
    inherit (stdenv.hostPlatform) system;
  };

  bowerPackages = buildBowerComponents {
    name = "${cryptpad.name}-bower-packages";
    # this list had to be tweaked by hand:
    # * add the second bootstrap ~3.1.1 entry
    generated = ./bower-packages.nix;
    src = cryptpad.src;
  };

  # find an element in an attribute set
  findValue = pred: default: set:
    let
      list =
        lib.concatMap
        (name:
          let v = set.${name}; in
          if pred name v then [v] else []
        )
        (lib.attrNames set)
        ;
    in
      if list == [] then default
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
  };
in
  combined
