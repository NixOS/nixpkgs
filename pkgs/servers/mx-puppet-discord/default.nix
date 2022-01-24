{ stdenv, fetchFromGitHub, pkgs, lib, nodejs, nodePackages, pkg-config, libjpeg
, pixman, cairo, pango }:

let
  # No official version ever released
  src = fetchFromGitHub {
    owner = "matrix-discord";
    repo = "mx-puppet-discord";
    rev = "c17384a6a12a42a528e0b1259f8073e8db89b8f4";
    sha256 = "1yczhfpa4qzvijcpgc2pr10s009qb6jwlfwpcbb17g2wsx6zj0c2";
  };

  myNodePackages = import ./node-composition.nix {
    inherit pkgs nodejs;
    inherit (stdenv.hostPlatform) system;
  };

in myNodePackages.package.override {
  pname = "mx-puppet-discord";

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
