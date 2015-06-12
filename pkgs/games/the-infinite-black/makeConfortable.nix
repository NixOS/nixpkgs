{ pkgs ? import <nixpkgs> {}, ... }:
{deriv, bin, resources}:

with pkgs.stdenv.lib;

let

  newDeriv = {stdenv, mesa_glu, libX11, libXext, libXcursor, libXrandr, gcc, alsaLib}:
    stdenv.mkDerivation rec {
      inherit (deriv) name;

      src = deriv;

      phases = "installPhase";

      libs = [mesa_glu libX11 libXext libXcursor libXrandr alsaLib];

      inherit resources bin;

      installPhase = ''
        # copy source tree, fill up resources
        mkdir -p $out
        mkdir -p $out/$resources
        ${unlines (map (lib: "ln -s ${lib}/lib/*.so* $out/$resources/") libs)}

        ln -s /nix/store/2q4nir7g03b7qidk9m2r9wcq3ga1fv65-gcc-4.8.4/lib64/libstdc++.so.6 $out/$resources/libstdc++.so.6 #FIXME: figure this shit out

        cp -r $src/* $out/
        
        # patching file
        patchelf --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) --set-rpath $out/$resources $out/$bin

      '';
    };
in
  pkgs.callPackage newDeriv {}
