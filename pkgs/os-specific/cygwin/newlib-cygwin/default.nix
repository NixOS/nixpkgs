{
  lib,
  stdenv,
  stdenvNoCC,
  stdenvNoLibc,
  autoreconfHook,
  bison,
  buildPackages,
  cocom-tool-set,
  flex,
  perl,
  w32api,
  w32api-headers,

  headersOnly ? false,
}:

(if headersOnly then stdenvNoCC else stdenvNoLibc).mkDerivation (
  finalAttrs:
  {
    pname = "newlib-cygwin${lib.optionalString headersOnly "-headers"}";
    version = "3.6.4";

    src = buildPackages.fetchgit {
      url = "https://cygwin.com/git/newlib-cygwin.git";
      rev = "cygwin-${finalAttrs.version}";
      hash = "sha256-+WYKwqcDAc7286GzbgKKAxNJCOf3AeNnF8XEVPoor+g=";
    };

    outputs = [
      "out"
    ]
    ++ lib.optionals (!headersOnly) [
      "bin"
      "dev"
      "man"
    ];

    patches = [
      # Newer versions of gcc don't like struct winsize being used before being
      # declared. Backport of https://cygwin.com/cgit/newlib-cygwin/commit/?id=73600d68227e125af24b7de7c3fccbd4eb66ee03
      ./fix-winsize.patch
    ]
    ++ lib.optional (!headersOnly) [
      # https://cygwin.com/pipermail/cygwin-developers/2020-September/011970.html
      # This is required for boost coroutines to work. After we get to the point
      # where nix runs on cygwin, we can attempt to upstream this again.
      ./store-tls-pointer-in-win32-tls.patch
    ]
    # After cygwin hosted builds are working, we should upstream this
    ++ lib.optional (
      !headersOnly && stdenvNoLibc.hostPlatform != stdenvNoLibc.buildPlatform
    ) ./fix-cross.patch;

    passthru.w32api = if headersOnly then w32api-headers else w32api;

    meta = {
      homepage = "https://cygwin.com/";
      description = "A DLL which provides substantial POSIX API functionality on Windows.";
      license = with lib.licenses; [
        # newlib
        gpl2
        # winsup
        gpl3
      ];
      platforms = lib.platforms.cygwin;
      maintainers = [ lib.maintainers.corngood ];
    };
  }
  // (
    if headersOnly then
      {
        dontConfigure = true;
        dontBuild = true;

        installPhase = ''
          mkdir -p $out/include/
          cp -r newlib/libc/include/* $out/include/
          cp -r winsup/cygwin/include/* $out/include/
        '';
      }
    else
      {
        postPatch = ''
          patchShebangs --build winsup/cygwin/scripts
        '';

        autoreconfFlags = [
          "winsup"
        ]
        # Only reconfigure root when fix-cross.patch is applied. Otherwise the
        # autoconf version check will fail.
        ++ lib.optional (stdenvNoLibc.hostPlatform != stdenvNoLibc.buildPlatform) ".";

        env =
          let
            libflag = "-Wl,-L${lib.getLib w32api}${w32api.libdir or "/lib/w32api"}";
          in
          {
            CFLAGS_FOR_TARGET = toString [
              libflag
            ];

            CXXFLAGS_FOR_TARGET = toString [
              "-Wno-error=register"
              libflag
            ];
          };

        strictDeps = true;

        depsBuildBuild = [ buildPackages.stdenv.cc ];

        nativeBuildInputs = [
          autoreconfHook
          bison
          cocom-tool-set
          flex
          perl
        ];

        buildInputs = [ w32api ];

        makeFlags = [
          "tooldir=${placeholder "out"}"
        ];

        enableParallelBuilding = true;

        # this is explicitly -j1 in cygwin.cygport
        # without it the install order is non-deterministic
        enableParallelInstalling = false;

        hardeningDisable = [
          # conflicts with internal definition of 'bzero'
          "fortify"
          "stackprotector"
        ];

        configurePlatforms = [
          "build"
          "target"
        ];

        configureFlags = [
          "--disable-shared"
          "--disable-doc"
          "--enable-static"
          "--disable-dumper"
          "--with-cross-bootstrap"
        ]
        ++ lib.optional (stdenvNoLibc.hostPlatform != stdenvNoLibc.buildPlatform) [
          "ac_cv_prog_CC=gcc"
        ];

        allowedImpureDLLs = [
          "ADVAPI32.dll"
          "PSAPI.DLL"
          "NETAPI32.dll"
          "SHELL32.dll"
          "USER32.dll"
          "USERENV.dll"
          "dbghelp.dll"
          "ntdll.dll"
        ];
      }
  )
)
