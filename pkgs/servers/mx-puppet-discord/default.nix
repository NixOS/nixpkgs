{
  stdenv,
  fetchFromGitLab,
  pkgs,
  lib,
  node-pre-gyp,
  nodejs_18,
  pkg-config,
  libjpeg,
  pixman,
  cairo,
  pango,
  which,
  postgresql,
  giflib,
  cctools,
}:

let
  nodejs = nodejs_18;

  version = "0.1.1";

  src = fetchFromGitLab {
    group = "mx-puppet";
    owner = "discord";
    repo = "mx-puppet-discord";
    rev = "v${version}";
    hash = "sha256-ZhyjUt6Bz/0R4+Lq/IoY9rNjdwVE2qp4ZQLc684+T/0=";
  };

  myNodePackages = import ./node-composition.nix {
    inherit pkgs nodejs;
    inherit (stdenv.hostPlatform) system;
  };

in
myNodePackages.package.override {
  inherit version src;

  nativeBuildInputs = [
    node-pre-gyp
    nodejs.pkgs.node-gyp-build
    pkg-config
    which
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ cctools ];
  buildInputs = [
    libjpeg
    pixman
    cairo
    pango
    postgresql
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ giflib ];

  postRebuild = ''
    # Build typescript stuff
    npm run build
  '';

  postInstall = ''
    # Make an executable to run the server
    mkdir -p $out/bin
    cat <<EOF > $out/bin/mx-puppet-discord
    #!/bin/sh
    exec ${nodejs}/bin/node $out/lib/node_modules/@mx-puppet/discord/build/index.js "\$@"
    EOF
    chmod +x $out/bin/mx-puppet-discord
  '';

  meta = with lib; {
    description = "Discord puppeting bridge for matrix";
    license = licenses.asl20;
    homepage = "https://gitlab.com/mx-puppet/discord/mx-puppet-discord";
    maintainers = [ ];
    platforms = platforms.unix;
    mainProgram = "mx-puppet-discord";
  };
}
