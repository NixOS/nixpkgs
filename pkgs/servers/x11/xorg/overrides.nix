{
  callPackage,
  lib,
  config,
  stdenv,
  makeWrapper,
  fetchurl,
  fetchpatch,
  fetchFromGitLab,
  buildPackages,
  automake,
  autoconf,
  libiconv,
  libtool,
  intltool,
  gettext,
  gzip,
  python3,
  perl,
  freetype,
  tradcpp,
  fontconfig,
  meson,
  ninja,
  ed,
  fontforge,
  libGL,
  spice-protocol,
  zlib,
  libGLU,
  dbus,
  libunwind,
  libdrm,
  netbsd,
  ncompress,
  updateAutotoolsGnuConfigScriptsHook,
  mesa,
  udev,
  bootstrap_cmds,
  bison,
  flex,
  clangStdenv,
  autoreconfHook,
  mcpp,
  libepoxy,
  openssl,
  pkg-config,
  llvm,
  libxslt,
  libxcrypt,
  hwdata,
  xorg,
  windows,
  libgbm,
  mesa-gl-headers,
  dri-pkgconfig-stub,
}:

let
  inherit (stdenv.hostPlatform) isDarwin;

  malloc0ReturnsNullCrossFlag = lib.optional (
    stdenv.hostPlatform != stdenv.buildPlatform
  ) "--enable-malloc0returnsnull";

  addMainProgram =
    pkg:
    {
      mainProgram ? pkg.pname,
    }:
    pkg.overrideAttrs (attrs: {
      meta = attrs.meta // {
        inherit mainProgram;
      };
    });

  brokenOnDarwin =
    pkg:
    pkg.overrideAttrs (attrs: {
      meta = attrs.meta // {
        broken = isDarwin;
      };
    });
in
self: super:
{
  wrapWithXFileSearchPathHook = callPackage (
    {
      makeBinaryWrapper,
      makeSetupHook,
      writeScript,
    }:
    makeSetupHook
      {
        name = "wrapWithXFileSearchPathHook";
        propagatedBuildInputs = [ makeBinaryWrapper ];
      }
      (
        writeScript "wrapWithXFileSearchPathHook.sh" ''
          wrapWithXFileSearchPath() {
            paths=(
              "$out/share/X11/%T/%N"
              "$out/include/X11/%T/%N"
              "${xorg.xbitmaps}/include/X11/%T/%N"
            )
            for exe in $out/bin/*; do
              wrapProgram "$exe" \
                --suffix XFILESEARCHPATH : $(IFS=:; echo "''${paths[*]}")
            done
          }
          postInstallHooks+=(wrapWithXFileSearchPath)
        ''
      )
  ) { };

  mkfontdir = xorg.mkfontscale;

  xdpyinfo = super.xdpyinfo.overrideAttrs (attrs: {
    configureFlags = attrs.configureFlags or [ ] ++ malloc0ReturnsNullCrossFlag;
    preConfigure =
      attrs.preConfigure or ""
      # missing transitive dependencies
      + lib.optionalString stdenv.hostPlatform.isStatic ''
        export NIX_CFLAGS_LINK="$NIX_CFLAGS_LINK -lXau -lXdmcp"
      '';
    meta = attrs.meta // {
      mainProgram = "xdpyinfo";
    };
  });

  xdm = super.xdm.overrideAttrs (attrs: {
    buildInputs = attrs.buildInputs ++ [ libxcrypt ];
    configureFlags =
      attrs.configureFlags or [ ]
      ++ [
        "ac_cv_path_RAWCPP=${stdenv.cc.targetPrefix}cpp"
      ]
      ++
        lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform)
          # checking for /dev/urandom... configure: error: cannot check for file existence when cross compiling
          [
            "ac_cv_file__dev_urandom=true"
            "ac_cv_file__dev_random=true"
          ];
    meta = attrs.meta // {
      mainProgram = "xdm";
    };
  });

  xf86inputevdev = super.xf86inputevdev.overrideAttrs (attrs: {
    outputs = [
      "out"
      "dev"
    ]; # to get rid of xorgserver.dev; man is tiny
    preBuild = "sed -e '/motion_history_proc/d; /history_size/d;' -i src/*.c";
    configureFlags = [
      "--with-sdkdir=${placeholder "dev"}/include/xorg"
    ];
  });

  xf86inputmouse = super.xf86inputmouse.overrideAttrs (attrs: {
    configureFlags = [
      "--with-sdkdir=${placeholder "out"}/include/xorg"
    ];
    meta = attrs.meta // {
      broken = isDarwin; # never worked: https://hydra.nixos.org/job/nixpkgs/trunk/xorg.xf86inputmouse.x86_64-darwin
    };
  });

  xf86inputjoystick = super.xf86inputjoystick.overrideAttrs (attrs: {
    configureFlags = [
      "--with-sdkdir=${placeholder "out"}/include/xorg"
    ];
    meta = attrs.meta // {
      broken = isDarwin; # never worked: https://hydra.nixos.org/job/nixpkgs/trunk/xorg.xf86inputjoystick.x86_64-darwin
    };
  });

  xf86inputkeyboard = super.xf86inputkeyboard.overrideAttrs (attrs: {
    meta = attrs.meta // {
      platforms = lib.platforms.freebsd ++ lib.platforms.netbsd ++ lib.platforms.openbsd;
    };
  });

  xf86inputlibinput = super.xf86inputlibinput.overrideAttrs (attrs: {
    outputs = [
      "out"
      "dev"
    ];
    configureFlags = [
      "--with-sdkdir=${placeholder "dev"}/include/xorg"
    ];
  });

  xf86inputsynaptics = super.xf86inputsynaptics.overrideAttrs (attrs: {
    outputs = [
      "out"
      "dev"
    ]; # *.pc pulls xorgserver.dev
    configureFlags = [
      "--with-sdkdir=${placeholder "dev"}/include/xorg"
      "--with-xorg-conf-dir=${placeholder "out"}/share/X11/xorg.conf.d"
    ];
  });

  xf86inputvmmouse = super.xf86inputvmmouse.overrideAttrs (attrs: {
    configureFlags = [
      "--sysconfdir=${placeholder "out"}/etc"
      "--with-xorg-conf-dir=${placeholder "out"}/share/X11/xorg.conf.d"
      "--with-udev-rules-dir=${placeholder "out"}/lib/udev/rules.d"
    ];

    meta = attrs.meta // {
      platforms = [
        "i686-linux"
        "x86_64-linux"
      ];
    };
  });

  xf86inputvoid = brokenOnDarwin super.xf86inputvoid; # never worked: https://hydra.nixos.org/job/nixpkgs/trunk/xorg.xf86inputvoid.x86_64-darwin
  xf86videodummy = brokenOnDarwin super.xf86videodummy; # never worked: https://hydra.nixos.org/job/nixpkgs/trunk/xorg.xf86videodummy.x86_64-darwin

  # Obsolete drivers that don't compile anymore.
  xf86videoark = super.xf86videoark.overrideAttrs (attrs: {
    meta = attrs.meta // {
      broken = true;
    };
  });
  xf86videogeode = super.xf86videogeode.overrideAttrs (attrs: {
    meta = attrs.meta // {
      broken = true;
    };
  });
  xf86videoglide = super.xf86videoglide.overrideAttrs (attrs: {
    meta = attrs.meta // {
      broken = true;
    };
  });
  xf86videoi128 = super.xf86videoi128.overrideAttrs (attrs: {
    meta = attrs.meta // {
      broken = true;
    };
  });
  xf86videonewport = super.xf86videonewport.overrideAttrs (attrs: {
    meta = attrs.meta // {
      broken = true;
    };
  });
  xf86videos3virge = super.xf86videos3virge.overrideAttrs (attrs: {
    meta = attrs.meta // {
      broken = true;
    };
  });
  xf86videotga = super.xf86videotga.overrideAttrs (attrs: {
    meta = attrs.meta // {
      broken = true;
    };
  });
  xf86videov4l = super.xf86videov4l.overrideAttrs (attrs: {
    meta = attrs.meta // {
      broken = true;
    };
  });
  xf86videovoodoo = super.xf86videovoodoo.overrideAttrs (attrs: {
    meta = attrs.meta // {
      broken = true;
    };
  });
  xf86videowsfb = super.xf86videowsfb.overrideAttrs (attrs: {
    meta = attrs.meta // {
      broken = true;
    };
  });

  xf86videoomap = super.xf86videoomap.overrideAttrs (attrs: {
    env.NIX_CFLAGS_COMPILE = toString [ "-Wno-error=format-overflow" ];
  });

  xf86videoamdgpu = super.xf86videoamdgpu.overrideAttrs (attrs: {
    configureFlags = [ "--with-xorg-conf-dir=$(out)/share/X11/xorg.conf.d" ];
  });

  xf86videonouveau = super.xf86videonouveau.overrideAttrs (attrs: {
    nativeBuildInputs = attrs.nativeBuildInputs ++ [
      autoreconfHook
      buildPackages.xorg.utilmacros # For xorg-utils.m4 macros
      buildPackages.xorg.xorgserver # For xorg-server.m4 macros
    ];
    # fixes `implicit declaration of function 'wfbScreenInit'; did you mean 'fbScreenInit'?
    NIX_CFLAGS_COMPILE = "-Wno-error=implicit-function-declaration";
  });

  xf86videoglint = super.xf86videoglint.overrideAttrs (attrs: {
    nativeBuildInputs = attrs.nativeBuildInputs ++ [ autoreconfHook ];
    buildInputs = attrs.buildInputs ++ [ xorg.utilmacros ];
    # https://gitlab.freedesktop.org/xorg/driver/xf86-video-glint/-/issues/1
    meta = attrs.meta // {
      broken = true;
    };
  });

  xf86videosuncg6 = super.xf86videosuncg6.overrideAttrs (attrs: {
    meta = attrs.meta // {
      broken = isDarwin;
    }; # never worked: https://hydra.nixos.org/job/nixpkgs/trunk/xorg.xf86videosuncg6.x86_64-darwin
  });

  xf86videosunffb = super.xf86videosunffb.overrideAttrs (attrs: {
    meta = attrs.meta // {
      broken = isDarwin;
    }; # never worked: https://hydra.nixos.org/job/nixpkgs/trunk/xorg.xf86videosunffb.x86_64-darwin
  });

  xf86videosunleo = super.xf86videosunleo.overrideAttrs (attrs: {
    meta = attrs.meta // {
      broken = isDarwin;
    }; # never worked: https://hydra.nixos.org/job/nixpkgs/trunk/xorg.xf86videosunleo.x86_64-darwin
  });

  xf86videovmware = super.xf86videovmware.overrideAttrs (attrs: {
    env.NIX_CFLAGS_COMPILE = toString [ "-Wno-error=address" ]; # gcc12
    meta = attrs.meta // {
      platforms = [
        "i686-linux"
        "x86_64-linux"
      ];
    };
  });

  xf86videoqxl = super.xf86videoqxl.overrideAttrs (attrs: {
    buildInputs = attrs.buildInputs ++ [ spice-protocol ];
  });

  xf86videosiliconmotion = super.xf86videosiliconmotion.overrideAttrs (attrs: {
    meta = attrs.meta // {
      platforms = [
        "i686-linux"
        "x86_64-linux"
      ];
    };
  });

  xkbcomp = super.xkbcomp.overrideAttrs (attrs: {
    configureFlags = [ "--with-xkb-config-root=${xorg.xkeyboardconfig}/share/X11/xkb" ];
    meta = attrs.meta // {
      mainProgram = "xkbcomp";
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

  xclock = addMainProgram super.xclock { };

  xinit =
    (super.xinit.override {
      stdenv = if isDarwin then clangStdenv else stdenv;
    }).overrideAttrs
      (attrs: {
        nativeBuildInputs = attrs.nativeBuildInputs ++ lib.optional isDarwin bootstrap_cmds;
        depsBuildBuild = [ buildPackages.stdenv.cc ];
        configureFlags = [
          "--with-xserver=${xorg.xorgserver.out}/bin/X"
        ]
        ++ lib.optionals isDarwin [
          "--with-bundle-id-prefix=org.nixos.xquartz"
          "--with-launchdaemons-dir=\${out}/LaunchDaemons"
          "--with-launchagents-dir=\${out}/LaunchAgents"
        ];
        postPatch = ''
          # Avoid replacement of word-looking cpp's builtin macros in Nix's cross-compiled paths
          substituteInPlace Makefile.in --replace "PROGCPPDEFS =" "PROGCPPDEFS = -Dlinux=linux -Dunix=unix"
        '';
        propagatedBuildInputs =
          attrs.propagatedBuildInputs or [ ]
          ++ [ xorg.xauth ]
          ++ lib.optionals isDarwin [
            xorg.libX11
            xorg.xorgproto
          ];
        postFixup = ''
          sed -i $out/bin/startx \
            -e '/^sysserverrc=/ s:=.*:=/etc/X11/xinit/xserverrc:' \
            -e '/^sysclientrc=/ s:=.*:=/etc/X11/xinit/xinitrc:'
        '';
        meta = attrs.meta // {
          mainProgram = "xinit";
        };
      });

  xf86videointel = super.xf86videointel.overrideAttrs (attrs: {
    # the update script only works with released tarballs :-/
    name = "xf86-video-intel-2024-05-06";
    src = fetchFromGitLab {
      domain = "gitlab.freedesktop.org";
      group = "xorg";
      owner = "driver";
      repo = "xf86-video-intel";
      rev = "ce811e78882d9f31636351dfe65351f4ded52c74";
      sha256 = "sha256-PKCxFHMwxgbew0gkxNBKiezWuqlFG6bWLkmtUNyoF8Q=";
    };
    buildInputs = attrs.buildInputs ++ [
      xorg.libXScrnSaver
      xorg.libXv
      xorg.pixman
    ];
    nativeBuildInputs = attrs.nativeBuildInputs ++ [
      autoreconfHook
      xorg.utilmacros
      xorg.xorgserver
    ];
    configureFlags = [
      "--with-default-dri=3"
      "--enable-tools"
    ];
    patches = [ ./use_crocus_and_iris.patch ];

    meta = attrs.meta // {
      platforms = [
        "i686-linux"
        "x86_64-linux"
      ];
    };
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

  xfd = addMainProgram super.xfd { };
  xfs = addMainProgram super.xfs { };
  xinput = addMainProgram super.xinput { };
  xkbevd = addMainProgram super.xkbevd { };
  xkbprint = addMainProgram super.xkbprint { };
  xload = addMainProgram super.xload { };

  xpr = addMainProgram super.xpr { };

  xrdb = super.xrdb.overrideAttrs (attrs: {
    configureFlags = [ "--with-cpp=${mcpp}/bin/mcpp" ];
    meta = attrs.meta // {
      mainProgram = "xrdb";
    };
  });

  xwd = addMainProgram super.xwd { };
}

# deprecate some packages
// lib.optionalAttrs config.allowAliases {
  fontbitstreamspeedo = throw "Bitstream Speedo is an obsolete font format that hasn't been supported by Xorg since 2005"; # added 2025-09-24
}
