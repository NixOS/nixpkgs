{
  lib,
  stdenv,
  pkgs,
  fetchFromGitHub,
  runCommand,
  buildNpmPackage,
  nodejs_18,
  tone,
  ffmpeg-full,
  util-linux,
  python3,
  getopt
}:

let
  nodejs = nodejs_18;

  pname = "audiobookshelf";
  version = "2.5.0";

  src = fetchFromGitHub {
    owner = "advplyr";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-yPDByM09rc9zRLh0ONcY5bScY4NOrKDv0Pdwo97Czcs=";
  };

  client = buildNpmPackage {
    pname = "${pname}-client";
    inherit version;

    src = runCommand "cp-source" {} ''
      cp -r ${src}/client $out
    '';

    NODE_OPTIONS = "--openssl-legacy-provider";

    npmBuildScript = "generate";
    npmDepsHash = "sha256-ZNkHDNjaQbUt3oWnNIYPYkcvjelieY4RJxNSbzR1+JM=";
  };

  wrapper = import ./wrapper.nix {
    inherit stdenv ffmpeg-full tone pname nodejs getopt;
  };

in buildNpmPackage {
  inherit pname version src;

  buildInputs = [ util-linux ];
  nativeBuildInputs = [ python3 ];

  dontNpmBuild = true;
  npmInstallFlags = [ "--only-production" ];
  npmDepsHash = "sha256-PVgK8R8sf16KKQS/mPXtvit9CW9+4Gc9Onpaw+SSgNI=";

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
