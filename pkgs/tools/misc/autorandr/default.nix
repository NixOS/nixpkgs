{ fetchgit
, stdenv
, python3Packages
, fetchFromGitHub }:

let
  python = python3Packages.python;
  wrapPython = python3Packages.wrapPython;
  date = "2016-11-23";
in
  stdenv.mkDerivation {
    name = "autorandr-unstable-${date}";

    buildInputs = [ python wrapPython ];

    phases = [ "unpackPhase" "installPhase" ];

    installPhase = ''
      # install bash completions
      mkdir -p $out/bin $out/libexec $out/etc/bash_completion.d
      cp -v contrib/bash_completion/autorandr $out/etc/bash_completion.d

      # install autorandr bin
      cp autorandr.py $out/bin/autorandr
      wrapPythonProgramsIn $out/bin/autorandr $out
    '';

    src = fetchFromGitHub {
      owner = "phillipberndt";
      repo = "autorandr";
      rev = "53d29f99275aebf14240ea95f2d7022b305738d5";
      sha256 = "0pza4wfkzv7mmg2m4pf3n8wk0p7cy6bfqknn8ywz51r8ja16cqfj";
    };

    meta = {
      homepage = "http://github.com/phillipberndt/autorandr/";
      description = "Auto-detect the connect display hardware and load the appropiate X11 setup using xrandr";
      license = stdenv.lib.licenses.gpl3Plus;
      maintainers = [ stdenv.lib.maintainers.coroa ];
      platforms = stdenv.lib.platforms.unix;
    };
  }
