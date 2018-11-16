{ stdenv,
  fetchFromGitHub,
  makeWrapper,
  nodePackages,
  pkgs ? import <nixpkgs> {
    inherit system;
  },
  system ? builtins.currentSystem,
  nodejs ? pkgs."nodejs-8_x"}:

let
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
  nodePath = "${nodePackages."turtl-server-build-deps-../../servers/turtl-server"}/lib/node_modules/turtl-server/node_modules";
in stdenv.mkDerivation {
  inherit name version src;

  buildInputs = [ makeWrapper nodejs nodePackages."turtl-server-build-deps-../../servers/turtl-server" ];

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
    wrapProgram $out/bin/turtl-server --set NODE_PATH "${nodePath}"
    wrapProgram $out/scripts/init-db.sh --set NODE_PATH "${nodePath}"
  '';

  meta = with stdenv.lib; {
    description = "Turtl notebook server";
    license = licenses.agpl3;
    homepage = https://github.com/turtl/server;
    maintainers = [ maintainers.raquelgb maintainers.rafaelgg ];
    platforms = platforms.linux;
  };
}
