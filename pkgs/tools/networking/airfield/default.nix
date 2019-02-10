{ stdenv, fetchFromGitHub
, pkgs, makeWrapper, buildEnv
, nodejs
}:

let
  nodePackages = import ./node.nix {
    inherit pkgs;
    system = stdenv.hostPlatform.system;
  };

  runtimeEnv = buildEnv {
    name = "airfield-runtime";
    paths = with nodePackages; [
      nodePackages."express-3.0.5" nodePackages."swig-0.14.0"
      nodePackages."consolidate-0.10.0" redis connect-redis
      async request
    ];
  };

  name = "airfield-${version}";
  version = "2015-01-04";

  src = stdenv.mkDerivation {
    name = "${name}-src";
    inherit version;

    src = fetchFromGitHub {
      owner = "emblica";
      repo = "airfield";
      rev = "f021b19a35be3db9be7780318860f3b528c48641";
      sha256 = "1xk69x89kgg98hm7c2ysyfmg7pkvgkpg4wym6v5cmdkdid08fsgs";
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
    mkdir -p $out/bin
    cat >$out/bin/airfield <<EOF
      #!${stdenv.shell}
      ${nodejs}/bin/node ${src}/airfield.js
    EOF
  '';

  postFixup = ''
    chmod +x $out/bin/airfield
    wrapProgram $out/bin/airfield \
      --set NODE_PATH "${runtimeEnv}/lib/node_modules"
  '';

  meta = with stdenv.lib; {
    description = "A web-interface for hipache-proxy";
    license = licenses.mit;
    homepage = https://github.com/emblica/airfield;
    maintainers = with maintainers; [ offline ma27 ];
    platforms = platforms.linux;
  };
}
