{ pkgs, stdenv, lib, makeDesktopItem, makeWrapper, fetchurl, appimageTools
, undmg, ... }:
let
  pname = "insomnium";
  version = "0.2.3-a";
  appname = "Insomnium";
  name = "${appname}.Core-${version}";
  meta = with lib; {
    description =
      "Fast local API testing tool that is privacy-focused and 100% local";
    homepage = "https://github.com/ArchGPT/insomnium";
    license = licenses.mit;
    maintainers = [ "nephalemsec" ];
  };

  filename =
    if stdenv.isDarwin then "${name}.signed.dmg" else "${name}.AppImage";

  src = pkgs.fetchurl {
    url =
      "https://github.com/ArchGPT/insomnium/releases/download/core%40${version}/${filename}";
    sha256 = if stdenv.isDarwin then
      "sha256-OlYfoNNBPSMYDVSIsANKW7yy1DPkYA4x0ALgyipS2d8="
    else
      "sha256-hFpAFxyoBtQPH+NPeQz9wjJSpyPm6yLfjXOQSomnoXE=";
  };

  icon = fetchurl {
    url =
      "https://raw.githubusercontent.com/ArchGPT/insomnium/main/packages/insomnia/src/icons/icon.png";
    hash = "sha256-oz/x2kzMOHhoTut/G9SUdI+yXNbv/RT2Y1XN49PJslo=";
  };

  desktopItem = makeDesktopItem {
    name = "insomnium";
    desktopName = "Insomnium";
    comment = "Tiling window manager for macOS along the lines of xmonad.";
    icon = "insomnium";
    exec = "insomnium %u";
    categories = [ "Office" ];
    mimeTypes = [ "x-scheme-handler/insomnium" ];
  };

  darwin = stdenv.mkDerivation {
    inherit desktopItem icon name src;

    meta = meta // { platforms = [ "x86_64-darwin" "aarch64-darwin" ]; };

    sourceRoot = "${appname}.app";

    nativeBuildInputs = [ makeWrapper undmg ];

    installPhase = ''
      runHook preInstall
      mkdir -p $out/{Applications/${appname}.app,bin}
      cp -R . $out/Applications/${appname}.app
      makeWrapper $out/Applications/${appname}.app/Contents/MacOS/${appname} $out/bin/${pname}
      runHook postInstall
    '';
  };

  linux = pkgs.appimageTools.wrapType1 {
    inherit name src;

    meta = meta // { platforms = [ "x86_64-linux" ]; };

    extraInstallCommands = ''
      mv $out/bin/${name} $out/bin/${pname}

      mkdir -p $out/share/applications $out/share/icons
      install -D ${icon} $out/share/icons/hicolor/scalable/apps/${pname}.svg
      cp -r ${desktopItem} $out/share/applications/${name}.desktop
    '';

    extraPkgs = pkgs: with pkgs; [ mesa ];
  };

in if stdenv.isDarwin then darwin else linux


