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
  version = "2.4.4";

  src = fetchFromGitHub {
    owner = "advplyr";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-W0Vk1G/NI2u/iWhR5Q9Dwo9Ndq4QDiWUae6K22QfHfo=";
  };

  client = buildNpmPackage {
    pname = "${pname}-client";
    inherit version;

    src = runCommand "cp-source" {} ''
      cp -r ${src}/client $out
    '';

    NODE_OPTIONS = "--openssl-legacy-provider";

    npmBuildScript = "generate";
    npmDepsHash = "sha256-ep67S92WWvZO578EIpJCkdgMJAG/qJLe8twy4663RHQ=";
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
  npmDepsHash = "sha256-SutXEc9kKV/9E/Sh1gl49W6JcN/w+6FIJwL8rxPbBVA=";

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
