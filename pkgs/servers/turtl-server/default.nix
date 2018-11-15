{ stdenv,
  fetchFromGitHub,
  makeWrapper,
  pkgs ? import <nixpkgs> {
    inherit system;
  }, system ? builtins.currentSystem, nodejs ? pkgs."nodejs-8_x"}:

let
  nodePackages = import ./node.nix {
    inherit pkgs;
    system = stdenv.hostPlatform.system;
  };
  name = "turtl-server-${version}";
  version = "2018-11-05";
  src = stdenv.mkDerivation {
    name = "${name}-src";
    inherit version;

    src = fetchFromGitHub {
      owner = "turtl";
      repo = "server";
      rev = "ff1635b856a0ce0d4ca0205b6e862ffa913154ec";
      sha256 = "0w0bbys3spwdzgvzcpna94vpyl76h6li6yybbqpzwnvsv42knpyg";
    };

    dontBuild = true;

    installPhase = ''
      mkdir $out
      cp -R . $out
    '';
  };
in stdenv.mkDerivation {
  inherit name version src;

  buildInputs = [ makeWrapper nodejs ];

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin $out/scripts
    cat > $out/bin/turtl-server <<EOF
      #!${stdenv.shell}/bin/sh
      ${nodejs}/bin/node ${src}/server.js
    EOF
    cat > $out/scripts/init-db.sh <<EOF
      #!${stdenv.shell}/bin/sh
      ${nodejs}/bin/node ${src}/tools/create-db-schema.js
    EOF
    cp ${src}/scripts/install-plugins.sh $out/scripts
  '';

  postFixup = ''
    chmod +x $out/bin/turtl-server $out/scripts/init-db.sh $out/scripts/install-plugins.sh
    wrapProgram $out/bin/turtl-server \
      --set NODE_PATH "${nodePackages.shell.nodeDependencies}/lib/node_modules"
    wrapProgram $out/scripts/init-db.sh \
      --set NODE_PATH "${nodePackages.shell.nodeDependencies}/lib/node_modules"
  '';

  meta = with stdenv.lib; {
    description = "Turtl notebook server";
    license = licenses.agpl3;
    homepage = https://github.com/turtl/server;
    maintainers = [ maintainers.raquelgb maintainers.rafaelgg ];
    platforms = platforms.linux;
  };
}
