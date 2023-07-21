{ lib, stdenv, pkgs, fetchFromGitHub, runCommand, buildNpmPackage, nodejs_18, tone, ffmpeg-full, util-linux, libwebp }:

let
  nodejs = nodejs_18;

  pname = "audiobookshelf";
  version = "2.2.23";

  src = fetchFromGitHub {
    owner = "advplyr";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-dmeqxXrVKXFIYI5/CBvGN5wAssY2DC6fIRDr2+0EL+I=";
  };

  client = buildNpmPackage {
    pname = "${pname}-client";
    inherit version;

    src = runCommand "cp-source" {} ''
      cp -r ${src}/client $out
    '';

    NODE_OPTIONS = "--openssl-legacy-provider";

    npmBuildScript = "generate";
    npmDepsHash = "sha256-W4S8+4V4CrU9b+nbuH3+kKQKlIkOT9i72+YAWO/3gCQ=";
  };

  wrapper = import ./wrapper.nix {
    inherit stdenv ffmpeg-full tone pname nodejs;
  };

in buildNpmPackage {
  inherit pname version src;

  buildInputs = [ util-linux ];

  dontNpmBuild = true;
  npmInstallFlags = [ "--only-production" ];
  npmDepsHash = "sha256-XBQNLcFHq6U/yknlXiIEGulTDTw1wLBnhEi3h5dtBuE=";

  installPhase = ''
    mkdir -p $out/opt/client
    cp -r index.js server package* node_modules $out/opt/
    cp -r ${client}/lib/node_modules/${pname}-client/dist $out/opt/client/dist
    mkdir $out/bin

    echo '${wrapper}' > $out/bin/${pname}
    echo "  exec ${nodejs}/bin/node $out/opt/index.js" >> $out/bin/${pname}

    chmod +x $out/bin/${pname}
  '';

  meta = with lib; {
    homepage = "https://www.audiobookshelf.org/";
    description = "Self-hosted audiobook and podcast server";
    license = licenses.gpl3;
    maintainers = [ maintainers.jvanbruegge ];
    platforms = platforms.linux;
  };
}
