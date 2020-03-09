{ autoPatchelfHook, appimageTools, desktop-file-utils, stdenv, fetchurl
  , fetchzip, fetchFromGitHub }:

# fetchzip is for compatibility, bother AppImage builder about that :
# https://docs.appimage.org/packaging-guide/distribution.html#do-not-put-appimages-into-other-archives


let
  self = appimagePackages;
  appimagePackages = with self; {

  buildInputs = [ desktop-file-utils autoPatchelfHook ];
  buildAppImage = {
    name,
    version,
    src,
    meta,
    ...
  } @ attrs:
    let
      installPhase = ''
        cd $src
        # fixup and install desktop file
        desktopitem="$(ls *.desktop)"
        desktop-file-install "$desktopitem" --dir $out/share/applications \
          --set-key Exec --set-value $binary
        mv $out/share/applications/"$desktopitem" $out/share/applications/$name.desktop

        #TODO: write a more generic code to read icon path from $desktopitem
        
        install -m 444 -D $icon $out/share/icons/hicolor/512x512/apps/$icon
      '';
      name = "${attrs.name}-${attrs.version}";
      attrs' = builtins.removeAttrs attrs ["version"];
    in appimageTools.wrapType2 (attrs' //  {
      inherit name src;
      meta = {
        license = stdenv.lib.licenses.unfree;
        platforms = [ "x86_64-linux" ];
        description = throw "please write meta.description";
      } // attrs'.meta;
  });

  beakerbrowser = buildAppImage rec {
      name = "beakerbrowser";
      version = "0.8.8";
      src = fetchurl {
        url = "https://github.com/beakerbrowser/beaker/releases/download/${version}/Beaker.Browser.${version}.AppImage";
        sha256 = "a190f1ca3266b2cb62a76b5a957a3e42b14726ca2732a2797c6fce40aaead695";
      };
      meta.description = "Experimental peer-to-peer Web browser";
  };

  colobot = buildAppImage rec {
      name = "colobot";
      version = "0.1.12-alpha";
      src = fetchurl {
        url = "https://colobot.info/files/releases/0.1.12-alpha/Colobot-${version}-x86_64.AppImage";
        sha256 = "da1b5b3ac8a072d1999c2ac8c65a6c1e0aad3c1a97e5dfd72c9a8c7f30c60fa5";
      };
      meta.description = "RTS game, where you can program your units (bots) in a language called CBOT";
      meta.license = stdenv.lib.licenses.gpl3;
  };

  retroshare = buildAppImage rec {
      name = "retroshare";
      version = "0.6.4";
      extraPkgs = pkgs: with pkgs; [ gmp ];
      src = fetchurl {
        url = "https://download.opensuse.org/repositories/network:/retroshare/AppImage/retroshare-gui-${version}-latest-x86_64.AppImage";
        sha256 = "1brxvm39q5lnnn7ahlsivi9glngn0vsf8kjkgjck3nwrql7pm5x8";
      };
      meta.description = "Decentralized Social Sharing Network";
  };

};

in self
