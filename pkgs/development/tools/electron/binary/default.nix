{ callPackage }:

let
  mkElectron = callPackage ./generic.nix { };
in
rec {
  electron-bin = electron_29-bin;

  electron_24-bin = mkElectron "24.8.6" {
    armv7l-linux = "8f46901667a904a62df7043991f20dc1c2a00370a42159976855458562cda8fc";
    aarch64-linux = "599e78a3a8127828ea3fa444927e7e51035dba9811ce0d81d59ad9b0bd02b4f6";
    x86_64-linux = "61e87bbd361da101c6a8363cc9c1f8b8b51db61b076cf495d3f4424303265a96";
    x86_64-darwin = "067ce05d628b44e1393369c506268915081ac9d96c0973d367262c71dcd91078";
    aarch64-darwin = "d9093e6928b2247336b3f0811e4f66c4ae50a719ec9399c393ac9556c8e56cee";
    headers = "009p1ffh2cyn98fcmprrjzq79jysp7h565v4f54wvjxjsq2nkr97";
  };

  electron_27-bin = mkElectron "27.0.0" {
    armv7l-linux = "81070012b0abbd763c59301044585be7a0f0092d80f9a8507744720e267dae2e";
    aarch64-linux = "202c5c6817081739e7bf15127c17c84ce2e553457c69a17557dec0928d40f354";
    x86_64-linux = "6c31e5733513c86eb5bb30169800bba5de8a055baadd9e0a5d153ea8fd2324ae";
    x86_64-darwin = "8c2b944f3949265526410704ecd925c85ebb20d61f5c739081336bd1d29bd083";
    aarch64-darwin = "2fc319c53f6dc61e2e424d46712caead7022b5124c9674f3b15b45c556dd0623";
    headers = "1pb8xhaarkmgss00ap4jbf693i03z4mwh5ilpkz6dsg1b9fka84q";
  };

  electron_28-bin = mkElectron "28.0.0" {
    armv7l-linux = "e41686b6ce7be7efb74d1f3fb4c912be31506b51770ceffa4e66b94164dac5b8";
    aarch64-linux = "32f9f7592359cf8b341946b41d758466533bd7a2bc0dc316072a3a1af4b92d84";
    x86_64-linux = "d66b6774b886bd57519d49b9eb8e6e745b523519414a8819f67aa19f76e2b53c";
    x86_64-darwin = "a5fdc70519b2c17a708920af2b998fc067ff0a18ba9f97d690cfab6bac23bd7a";
    aarch64-darwin = "d64947fee370a3b111f170399969977959848f2a2f544a1ae5dc081fc2df75cf";
    headers = "1lrwc03ffrf4bi2faampkx7yg0iqsrcp86znp9fw6ajwdwgqsc81";
  };

  electron_29-bin = mkElectron "29.1.4" {
    armv7l-linux = "12a7e6a8ef214d104ee72eb6636a055c9c6d41bcc58f31a8dc48b9bc8fd0fcb5";
    aarch64-linux = "0d41a51d45712d0312dd24d79a395e80280bd8365ebb8e46c252cadcb780354b";
    x86_64-linux = "83a37103b67378a9073898541cfc4af8b5de708da15135f060bf26993ab426b5";
    x86_64-darwin = "e7887396018840ca482eb481edbff2e9a5580998412ffd217f70fad02f23969d";
    aarch64-darwin = "7ad63253fd6de9dbb337efbf4a6d0161f0e4c5953243bec27de488db98ef8a6c";
    headers = "0plc831v1fva2yrwg1zal5n9wkgy0f6v1by6b3jh8wjgrsrkhk00";
  };
}
