{ nixpkgs ? import <nixpkgs> {}, pythonPkgs ? nixpkgs.pkgs.python3Packages }:

let
  inherit (nixpkgs) pkgs lib fetchFromGitHub;
  inherit pythonPkgs;

  f = { buildPythonPackage, setuptools, pynput }:
    buildPythonPackage rec {
      name = "keep-presence";
      version = "1.0.5";

      meta = with lib; {
        description = ''
          This program moves the mouse or press a key when it detects that you are away.
          It won't do anything if you are using your computer.
          Useful to trick your machine to think you are still working with it.
        '';
        homepage = https://github.com/carrot69/keep-presence;
        license = licenses.cc0;
        platforms = platforms.unix;
      };

      # Using a fork with proper shebangs and setup.py added, will open PR
      # to carrot69's (original author) repo to see if they would like
      # to merge.
      src = fetchFromGitHub {
        owner = "carrot69";
        repo = "keep-presence";
        rev = "f55ba91bf78681e4e99e39ed63be4810c81e28c6";
        sha256 = "1a4r35pbdmd73767x3g41c3chjxjwqf3y4n3dhmh31s1lx7cahmv";
      } + /src;

      propagatedBuildInputs = with pythonPkgs; [ setuptools pynput ];

      doCheck = false;

      postInstall = ''
        mv -v $out/bin/keep-presence.py $out/bin/keep-presence
        patchShebangs $out/bin/keep-presence
        chmod +x $out/bin/keep-presence
      '';
    };

  drv = pythonPkgs.callPackage f {};

in
if pkgs.lib.inNixShell then drv.env else drv
