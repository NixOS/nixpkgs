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

  bitmap = addMainProgram super.bitmap { };

  editres = super.editres.overrideAttrs (attrs: {
    hardeningDisable = [ "format" ];
    meta = attrs.meta // {
      mainProgram = "editres";
    };
  });

  fonttosfnt = super.fonttosfnt.overrideAttrs (attrs: {
    meta = attrs.meta // {
      license = lib.licenses.mit;
      mainProgram = "fonttosfnt";
    };
  });

  iceauth = addMainProgram super.iceauth { };

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

  setxkbmap = super.setxkbmap.overrideAttrs (attrs: {
    postInstall = ''
      mkdir -p $out/share/man/man7
      ln -sfn ${xorg.xkeyboardconfig}/etc/X11 $out/share/X11
      ln -sfn ${xorg.xkeyboardconfig}/share/man/man7/xkeyboard-config.7.gz $out/share/man/man7
    '';
    meta = attrs.meta // {
      mainProgram = "setxkbmap";
    };
  });

  oclock = addMainProgram super.oclock { };

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

  xorgserver = super.xorgserver.overrideAttrs (
    attrs_passed:
    let
      attrs = attrs_passed // {
        buildInputs = attrs_passed.buildInputs ++ lib.optional (libdrm != null) libdrm.dev;
        postPatch = ''
          for i in dri3/*.c
          do
            sed -i -e "s|#include <drm_fourcc.h>|#include <libdrm/drm_fourcc.h>|" $i
          done
        '';
        meta = attrs_passed.meta // {
          mainProgram = "X";
        };
      };
    in
    attrs
    // (
      let
        version = lib.getVersion attrs;
        commonBuildInputs = attrs.buildInputs ++ [
          xorg.xtrans
          xorg.libxcvt
        ];
        commonPropagatedBuildInputs = [
          dbus
          libGL
          libGLU
          xorg.libXext
          xorg.libXfont
          xorg.libXfont2
          libepoxy
          libunwind
          xorg.libxshmfence
          xorg.pixman
          xorg.xorgproto
          zlib
        ];
        # XQuartz requires two compilations: the first to get X / XQuartz,
        # and the second to get Xvfb, Xnest, etc.
        darwinOtherX = xorg.xorgserver.overrideAttrs (oldAttrs: {
          configureFlags = oldAttrs.configureFlags ++ [
            "--disable-xquartz"
            "--enable-xorg"
            "--enable-xvfb"
            "--enable-xnest"
            "--enable-kdrive"
          ];
          postInstall = ":"; # prevent infinite recursion
        });

        fpgit =
          commit: sha256: name:
          fetchpatch (
            {
              url = "https://gitlab.freedesktop.org/xorg/xserver/-/commit/${commit}.diff";
              inherit sha256;
            }
            // lib.optionalAttrs (name != null) {
              name = name + ".patch";
            }
          );
      in
      if (!isDarwin) then
        {
          outputs = [
            "out"
            "dev"
          ];
          patches = [
            # The build process tries to create the specified logdir when building.
            #
            # We set it to /var/log which can't be touched from inside the sandbox causing the build to hard-fail
            ./dont-create-logdir-during-build.patch
          ];
          buildInputs = commonBuildInputs ++ [
            libdrm
            libgbm
            mesa-gl-headers
            dri-pkgconfig-stub
          ];
          propagatedBuildInputs =
            attrs.propagatedBuildInputs or [ ]
            ++ [ xorg.libpciaccess ]
            ++ commonPropagatedBuildInputs
            ++ lib.optionals stdenv.hostPlatform.isLinux [
              udev
            ];
          depsBuildBuild = [ buildPackages.stdenv.cc ];
          prePatch = lib.optionalString stdenv.hostPlatform.isMusl ''
            export CFLAGS+=" -D__uid_t=uid_t -D__gid_t=gid_t"
          '';
          configureFlags = [
            "--enable-kdrive" # not built by default
            "--enable-xephyr"
            "--enable-xcsecurity" # enable SECURITY extension
            "--with-default-font-path="
            # there were only paths containing "${prefix}",
            # and there are no fonts in this package anyway
            "--with-xkb-bin-directory=${xorg.xkbcomp}/bin"
            "--with-xkb-path=${xorg.xkeyboardconfig}/share/X11/xkb"
            "--with-xkb-output=$out/share/X11/xkb/compiled"
            "--with-log-dir=/var/log"
            "--enable-glamor"
            "--with-os-name=Nix" # r13y, embeds the build machine's kernel version otherwise
          ]
          ++ lib.optionals stdenv.hostPlatform.isMusl [
            "--disable-tls"
          ];

          env.NIX_CFLAGS_COMPILE = toString [
            # Needed with GCC 12
            "-Wno-error=array-bounds"
          ];

          postInstall = ''
            rm -fr $out/share/X11/xkb/compiled # otherwise X will try to write in it
            ( # assert() keeps runtime reference xorgserver-dev in xf86-video-intel and others
              cd "$dev"
              for f in include/xorg/*.h; do
                sed "1i#line 1 \"${attrs.pname}-${attrs.version}/$f\"" -i "$f"
              done
            )
          '';
          passthru = attrs.passthru // {
            inherit version; # needed by virtualbox guest additions
          };
        }
      else
        {
          nativeBuildInputs = attrs.nativeBuildInputs ++ [
            autoreconfHook
            bootstrap_cmds
            xorg.utilmacros
            xorg.fontutil
          ];
          buildInputs = commonBuildInputs ++ [
            bootstrap_cmds
            automake
            autoconf
            mesa
          ];
          propagatedBuildInputs = commonPropagatedBuildInputs ++ [
            xorg.libAppleWM
            xorg.xorgproto
          ];

          patches = [
            # XQuartz patchset
            (fetchpatch {
              url = "https://github.com/XQuartz/xorg-server/commit/e88fd6d785d5be477d5598e70d105ffb804771aa.patch";
              sha256 = "1q0a30m1qj6ai924afz490xhack7rg4q3iig2gxsjjh98snikr1k";
              name = "use-cppflags-not-cflags.patch";
            })
            (fetchpatch {
              url = "https://github.com/XQuartz/xorg-server/commit/75ee9649bcfe937ac08e03e82fd45d9e18110ef4.patch";
              sha256 = "1vlfylm011y00j8mig9zy6gk9bw2b4ilw2qlsc6la49zi3k0i9fg";
              name = "use-old-mitrapezoids-and-mitriangles-routines.patch";
            })
            (fetchpatch {
              url = "https://github.com/XQuartz/xorg-server/commit/c58f47415be79a6564a9b1b2a62c2bf866141e73.patch";
              sha256 = "19sisqzw8x2ml4lfrwfvavc2jfyq2bj5xcf83z89jdxg8g1gdd1i";
              name = "revert-fb-changes-1.patch";
            })
            (fetchpatch {
              url = "https://github.com/XQuartz/xorg-server/commit/56e6f1f099d2821e5002b9b05b715e7b251c0c97.patch";
              sha256 = "0zm9g0g1jvy79sgkvy0rjm6ywrdba2xjd1nsnjbxjccckbr6i396";
              name = "revert-fb-changes-2.patch";
            })
            ./darwin/bundle_main.patch
            ./darwin/stub.patch
          ];

          postPatch = attrs.postPatch + ''
            substituteInPlace hw/xquartz/mach-startup/stub.c \
              --subst-var-by XQUARTZ_APP "$out/Applications/XQuartz.app"
          '';

          configureFlags = [
            # note: --enable-xquartz is auto
            "CPPFLAGS=-I${./darwin/dri}"
            "--disable-libunwind" # libunwind on darwin is missing unw_strerror
            "--disable-glamor"
            "--with-default-font-path="
            "--with-apple-application-name=XQuartz"
            "--with-apple-applications-dir=\${out}/Applications"
            "--with-bundle-id-prefix=org.nixos.xquartz"
            "--with-sha1=CommonCrypto"
            "--with-xkb-bin-directory=${xorg.xkbcomp}/bin"
            "--with-xkb-path=${xorg.xkeyboardconfig}/share/X11/xkb"
            "--with-xkb-output=$out/share/X11/xkb/compiled"
            "--without-dtrace" # requires Command Line Tools for Xcode
          ];
          preConfigure = ''
            mkdir -p $out/Applications
            export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -Wno-error"
          '';
          postInstall = ''
            rm -fr $out/share/X11/xkb/compiled

            cp -rT ${darwinOtherX}/bin $out/bin
            rm -f $out/bin/X
            ln -s Xquartz $out/bin/X

            cp ${darwinOtherX}/share/man -rT $out/share/man
          '';
          passthru = attrs.passthru // {
            inherit version;
          };
        }
    )
  );

  # xvfb is used by a bunch of things to run tests
  # so try to reduce its reverse closure
  xvfb = super.xorgserver.overrideAttrs (old: {
    configureFlags = [
      "--enable-xvfb"
      "--disable-xorg"
      "--disable-xquartz"
      "--disable-xwayland"
      "--with-xkb-bin-directory=${xorg.xkbcomp}/bin"
      "--with-xkb-path=${xorg.xkeyboardconfig}/share/X11/xkb"
      "--with-xkb-output=$out/share/X11/xkb/compiled"
    ]
    ++ lib.optional stdenv.hostPlatform.isDarwin [
      "--without-dtrace"
    ];

    buildInputs = old.buildInputs ++ [
      dri-pkgconfig-stub
      libdrm
      libGL
      mesa-gl-headers
      xorg.pixman
      xorg.libXfont2
      xorg.xtrans
      xorg.libxcvt
      xorg.libxshmfence
    ];
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
