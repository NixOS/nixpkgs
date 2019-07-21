#TODO It may be possible to use symlinkjoin to add plugins if you write the unwrapped launcher script to not use readlink

# plugins is a list of derivations to symlink into <ghidraroot>/Ghidra/Extensions,
# this is entirely sufficient for ghidra to operate.
{
  stdenv, fetchurl, unzip, makeWrapper, autoPatchelfHook, # Utilities
  jdk, pam, # Deps
  lib, config, plugins ? [], extraLaunchers ? {}, # Ghidra
  pkgs #.lib
  }:

#Recursive let means these two need to be separate
let
  inherit (lib) jdkWrapper installPlugin unpackPlugin writeCustomLauncher;
in
let
  lib = pkgs.lib;
in

  stdenv.mkDerivation rec {
    name = "ghidra-${version}-bin";
    version = "9.0.2";

    src = fetchurl {
      url = "https://ghidra-sre.org/ghidra_9.0.2_PUBLIC_20190403.zip";
      sha256 = "17wfixab6fspf0kw9hrrx4nhxwqyqj36gncf3iimp7vf4rfddzqh";
      };

    nativeBuildInputs = [
      makeWrapper
      autoPatchelfHook
      unzip
      ];

    # For autoPatchelf
    buildInputs = [
      stdenv.cc.cc.lib
      pam
      ];

    propagatedBuildInputs = [
      jdk
      ];

    dontStrip = true;

    installPhase = ''
      mkdir -p -- "$out/${config.pkg_path}"
      cp -a -- * "$out/${config.pkg_path}"
      '';

    postFixup = ''
      mkdir -p -- "$out/bin"
      # Make wrappers
      ${lib.concatMapStrings (l: jdkWrapper "${config.pkg_path}/${l}" "bin/${builtins.baseNameOf l}") config.launchers}
      ${lib.concatStrings (lib.mapAttrsToList writeCustomLauncher extraLaunchers)}
      # Install plugins
      ${lib.concatMapStrings (p: installPlugin (unpackPlugin p)) plugins}
      '';

    meta = with lib; {
      description = "A software reverse engineering (SRE) suite of tools developed by NSA's Research Directorate in support of the Cybersecurity mission";
      homepage = "https://ghidra-sre.org/";
      platforms = [ "x86_64-linux" ];
      license = licenses.asl20;
      maintainers = [ maintainers.ck3d ];
      };
    }
