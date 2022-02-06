{ stdenv, fetchFromGitHub, pkgs, lib, nodejs-14_x, nodePackages, pkg-config, libjpeg
, pixman, cairo, pango }:

let
  nodejs = nodejs-14_x;
  # No official version ever released
  src = fetchFromGitHub {
    owner = "matrix-discord";
    repo = "mx-puppet-discord";
    rev = "bb6438a504182a7a64048b992179427587ccfded";
    sha256 = "0g2p5xwxxgvlnq0fg0x4q9x4asqyppdv6b5z6bvncm62kc70z6xk";
  };

  myNodePackages = import ./node-composition.nix {
    inherit pkgs nodejs;
    inherit (stdenv.hostPlatform) system;
  };

in myNodePackages.package.override {
  pname = "mx-puppet-discord";
  version = "2021-08-01";

  inherit src;

  nativeBuildInputs = [ nodePackages.node-pre-gyp pkg-config ];
  buildInputs = [ libjpeg pixman cairo pango ];

  postInstall = ''
    # Patch shebangs in node_modules, otherwise the webpack build fails with interpreter problems
    patchShebangs --build "$out/lib/node_modules/mx-puppet-discord/node_modules/"
    # compile Typescript sources
    npm run build

    # Make an executable to run the server
    mkdir -p $out/bin
    cat <<EOF > $out/bin/mx-puppet-discord
    #!/bin/sh
    exec ${nodejs}/bin/node $out/lib/node_modules/mx-puppet-discord/build/index.js "\$@"
    EOF
    chmod +x $out/bin/mx-puppet-discord
  '';

  meta = with lib; {
    description = "A discord puppeting bridge for matrix";
    license = licenses.asl20;
    homepage = "https://github.com/matrix-discord/mx-puppet-discord";
    maintainers = with maintainers; [ expipiplus1 ];
    platforms = platforms.unix;
  };
}
