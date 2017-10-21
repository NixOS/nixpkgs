{ appleDerivation_, applePackage, pkgs, stdenv }:
name: version: sha256: args: let
  n = stdenv.lib.removePrefix "lib" name;
  makeFile = ../. + builtins.toPath "/${name}/GNUmakefile";
  appleDerivation = appleDerivation_ name version sha256;
  in applePackage name version sha256 (args // {
    appleDerivation = a:
    appleDerivation (stdenv.lib.mergeAttrsConcatenateValues {
      __impureHostDeps = import ./impure_deps.nix;

      patchPhase = ''
        # allows including <Security/some-private-header.h>
        ln -s ${pkgs.darwin.osx_private_sdk}/PrivateSDK10.9.sparse.sdk/System/Library/Frameworks/Security.framework/Versions/A/PrivateHeaders Security

        grep -Rl MacErrors.h . | while read file; do
          substituteInPlace "''$file" --replace \
            '<CoreServices/../Frameworks/CarbonCore.framework/Headers/MacErrors.h>' \
            '"${pkgs.darwin.apple_sdk.sdk}/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/CarbonCore.framework/Versions/A/Headers/MacErrors.h"'
        done || true # grep returns 1 if it can't find the string
        
        grep -Rl MacTypes.h . | while read file; do
          substituteInPlace "''$file" --replace \
            '<CoreServices/../Frameworks/CarbonCore.framework/Headers/MacTypes.h>' \
            '"${pkgs.darwin.apple_sdk.sdk}/include/MacTypes.h"'
        done || true # grep returns 1 if it can't find the string
      '';
      preBuild = ''
        ln -s lib ${n}
        makeFlagsArray=(-j''$NIX_BUILD_CORES)
      '';
      buildInputs = [
        pkgs.gnustep.make
        pkgs.darwin.apple_sdk.frameworks.AppKit
        pkgs.darwin.apple_sdk.frameworks.Foundation
        pkgs.darwin.cf-private
      ];
      makeFlags = [
        "-f${makeFile}"
        "MAKEFILE_NAME=${makeFile}"
        "GNUSTEP_ABSOLUTE_INSTALL_PATHS=yes"
        "GNUSTEP_MAKEFILES=${pkgs.gnustep.make}/share/GNUstep/Makefiles"
        "LIB_LINK_INSTALL_DIR=\$(out)/lib"
      ];
      installFlags = [
        "${n}_INSTALL_DIR=\$(out)/lib"
        "${n}_HEADER_FILES_INSTALL_DIR=\$(out)/include/${n}"
        "GNUSTEP_HEADERS="
      ];
      NIX_CFLAGS_COMPILE = [
        "-isystem lib"
        "-iframework ${pkgs.darwin.Security}/Library/Frameworks"
        "-I."
        "-Wno-deprecated-declarations"
      ];
      NIX_LDFLAGS = with pkgs.darwin; with apple_sdk.frameworks; [
        "-L${libobjc}/lib"
        "-F${Foundation}/Library/Frameworks"
        "-F${AppKit}/Library/Frameworks"
        "-no_dtrace_dof"
      ];
    } a);
  })
