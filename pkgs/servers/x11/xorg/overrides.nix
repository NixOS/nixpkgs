{
  lib,
  pkgs,
  config,
  fetchpatch,
  automake,
  ed,
  xorg,
}:
self: super:
{
  mkfontdir = xorg.mkfontscale;

  xf86videovmware = super.xf86videovmware.overrideAttrs (attrs: {
    env.NIX_CFLAGS_COMPILE = toString [ "-Wno-error=address" ]; # gcc12
    meta = attrs.meta // {
      platforms = [
        "i686-linux"
        "x86_64-linux"
      ];
    };
  });

  xf86videosiliconmotion = super.xf86videosiliconmotion.overrideAttrs (attrs: {
    meta = attrs.meta // {
      platforms = [
        "i686-linux"
        "x86_64-linux"
      ];
    };
  });

  # xkeyboardconfig variant extensible with custom layouts.
  # See nixos/modules/services/x11/extra-layouts.nix
  xkeyboardconfig_custom =
    {
      layouts ? { },
    }:
    let
      patchIn = name: layout: ''
        # install layout files
        ${lib.optionalString (layout.compatFile != null) "cp '${layout.compatFile}'   'compat/${name}'"}
        ${lib.optionalString (layout.geometryFile != null) "cp '${layout.geometryFile}' 'geometry/${name}'"}
        ${lib.optionalString (layout.keycodesFile != null) "cp '${layout.keycodesFile}' 'keycodes/${name}'"}
        ${lib.optionalString (layout.symbolsFile != null) "cp '${layout.symbolsFile}'  'symbols/${name}'"}
        ${lib.optionalString (layout.typesFile != null) "cp '${layout.typesFile}'    'types/${name}'"}

        # add model description
        ${ed}/bin/ed -v rules/base.xml <<EOF
        /<\/modelList>
        -
        a
        <model>
          <configItem>
            <name>${name}</name>
            <description>${layout.description}</description>
            <vendor>${layout.description}</vendor>
          </configItem>
        </model>
        .
        w
        EOF

        # add layout description
        ${ed}/bin/ed -v rules/base.xml <<EOF
        /<\/layoutList>
        -
        a
        <layout>
          <configItem>
            <name>${name}</name>
            <shortDescription>${name}</shortDescription>
            <description>${layout.description}</description>
            <languageList>
              ${lib.concatMapStrings (lang: "<iso639Id>${lang}</iso639Id>\n") layout.languages}
            </languageList>
          </configItem>
          <variantList/>
        </layout>
        .
        w
        EOF
      '';
    in
    xorg.xkeyboardconfig.overrideAttrs (old: {
      nativeBuildInputs = old.nativeBuildInputs ++ [ automake ];
      postPatch = lib.concatStrings (lib.mapAttrsToList patchIn layouts);
    });

  xf86videoopenchrome = super.xf86videoopenchrome.overrideAttrs (attrs: {
    buildInputs = attrs.buildInputs ++ [ xorg.libXv ];
    patches = [
      # Pull upstream fix for -fno-common toolchains.
      (fetchpatch {
        name = "fno-common.patch";
        url = "https://github.com/freedesktop/openchrome-xf86-video-openchrome/commit/edb46574d4686c59e80569ba236d537097dcdd0e.patch";
        sha256 = "0xqawg9zzwb7x5vaf3in60isbkl3zfjq0wcnfi45s3hiii943sxz";
      })
    ];
  });
}

# deprecate some packages
// lib.optionalAttrs config.allowAliases {
  # keep-sorted start
  appres = lib.warnOnInstantiate "appres has been removed from xorg namespace, use pkgs.appres instead" pkgs.appres; # added 2026-01-10
  bdftopcf = lib.warnOnInstantiate "bdftopcf has been removed from xorg namespace, use pkgs.bdftopcf instead" pkgs.bdftopcf; # added 2026-01-10
  bitmap = lib.warnOnInstantiate "bitmap has been removed from xorg namespace, use pkgs.bitmap instead" pkgs.bitmap; # added 2026-01-10
  editres = lib.warnOnInstantiate "editres has been removed from xorg namespace, use pkgs.editres instead" pkgs.editres; # added 2026-01-10
  fontbitstreamspeedo = throw "Bitstream Speedo is an obsolete font format that hasn't been supported by Xorg since 2005"; # added 2025-09-24
  libXtrap = throw "XTrap was a proposed X11 extension that hasn't been in Xorg since X11R6 in 1994, it is deprecated and archived upstream."; # added 2025-12-13
  fonttosfnt = lib.warnOnInstantiate "fonttosfnt has been removed from xorg namespace, use pkgs.fonttosfnt instead" pkgs.fonttosfnt; # added 2026-01-10
  gccmakedep = lib.warnOnInstantiate "gccmakedep has been removed from xorg namespace, use pkgs.gccmakedep instead" pkgs.gccmakedep; # added 2026-01-10
  iceauth = lib.warnOnInstantiate "iceauth has been removed from xorg namespace, use pkgs.iceauth instead" pkgs.iceauth; # added 2026-01-10
  ico = lib.warnOnInstantiate "ico has been removed from xorg namespace, use pkgs.ico instead" pkgs.ico; # added 2026-01-10
  imake = lib.warnOnInstantiate "imake has been removed from xorg namespace, use pkgs.imake instead" pkgs.imake; # added 2026-01-10
  libdmx = lib.warnOnInstantiate "libdmx has been removed from xorg namespace, use pkgs.libdmx instead" pkgs.libdmx; # added 2026-01-10
  luit = lib.warnOnInstantiate "luit has been removed from xorg namespace, use pkgs.luit instead" pkgs.luit; # added 2026-01-10
  xf86videoglide = throw "The Xorg Glide video driver has been archived upstream due to being obsolete"; # added 2025-12-13
  xf86videoglint = throw ''
    The Xorg GLINT/Permedia video driver has been broken since xorg 21.
    see https://gitlab.freedesktop.org/xorg/driver/xf86-video-glint/-/issues/1''; # added 2025-12-13
  xf86videonewport = throw "The Xorg Newport video driver is broken and hasn't had a release since 2012"; # added 2025-12-13
  xf86videotga = throw "The Xorg TGA (aka DEC 21030) video driver is broken and hasn't had a release since 2012"; # added 2025-12-13
  xf86videowsfb = throw "The Xorg BSD wsdisplay framebuffer video driver is broken and hasn't had a release since 2012"; # added 2025-12-13
  xtrap = throw "XTrap was a proposed X11 extension that hasn't been in Xorg since X11R6 in 1994, it is deprecated and archived upstream."; # added 2025-12-13
  # keep-sorted end
}
