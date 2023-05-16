<<<<<<< HEAD
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
=======
{ lib, stdenv, pkgs, fetchFromGitHub, runCommand, buildNpmPackage, nodejs_18, tone, ffmpeg-full, util-linux, libwebp }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

let
  nodejs = nodejs_18;

  pname = "audiobookshelf";
<<<<<<< HEAD
  version = "2.3.3";
=======
  version = "2.2.20";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "advplyr";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-wSIA2KKDKf3DNgYNNIyYNT8xyPWCZvwLcWuDhWOZpLs=";
=======
    sha256 = "sha256-nQHWmBMPBPgIe1YQi8wFmZGnwHcmYFxzfWPxyTo16zk=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  client = buildNpmPackage {
    pname = "${pname}-client";
    inherit version;

    src = runCommand "cp-source" {} ''
      cp -r ${src}/client $out
    '';

    NODE_OPTIONS = "--openssl-legacy-provider";

    npmBuildScript = "generate";
<<<<<<< HEAD
    npmDepsHash = "sha256-s3CwGFK87podBJwAqh7JoMA28vnmf77iexrAbbwZlFk=";
  };

  wrapper = import ./wrapper.nix {
    inherit stdenv ffmpeg-full tone pname nodejs getopt;
=======
    npmDepsHash = "sha256-gCeLDYuC8uK8lEWTPCxr9NlOS6ADP+1oukYR7/xZ0aA=";
  };

  wrapper = import ./wrapper.nix {
    inherit stdenv ffmpeg-full tone pname nodejs;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

in buildNpmPackage {
  inherit pname version src;

  buildInputs = [ util-linux ];
<<<<<<< HEAD
  nativeBuildInputs = [ python3 ];

  dontNpmBuild = true;
  npmInstallFlags = [ "--only-production" ];
  npmDepsHash = "sha256-gueSlQh4tRTjIWvpNG2cj1np/zUGbjsnv3fA2owtiQY=";
=======

  dontNpmBuild = true;
  npmInstallFlags = [ "--only-production" ];
  npmDepsHash = "sha256-LYvI+7KXXXyH6UuWEc2YdqoSdvljclLr8LlG7Cm2Pv8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
