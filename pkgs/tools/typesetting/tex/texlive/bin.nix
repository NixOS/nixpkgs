{ lib, stdenv, fetchurl, fetchpatch, buildPackages
, texlive
, zlib, libiconv, libpng, libX11
, freetype, gd, libXaw, icu, ghostscript, libXpm, libXmu, libXext
, perl, perlPackages, python3Packages, pkg-config
, libpaper, graphite2, zziplib, harfbuzz, potrace, gmp, mpfr
, brotli, cairo, pixman, xorg, clisp, biber, woff2, xxHash
<<<<<<< HEAD
, makeWrapper, shortenPerlShebang, useFixedHashes, asymptote
, biber-ms
, tlpdb
=======
, makeWrapper, shortenPerlShebang
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

# Useful resource covering build options:
# http://tug.org/texlive/doc/tlbuild.html

let
  withSystemLibs = map (libname: "--with-system-${libname}");

  year = toString ((import ./tlpdb.nix)."00texlive.config").year;
  version = year; # keep names simple for now

<<<<<<< HEAD
  # detect and stop redundant rebuilds that may occur when building new fixed hashes
  assertFixedHash = name: src:
    if ! useFixedHashes || src ? outputHash then src else throw "The TeX Live package '${src.pname}' must have a fixed hash before building '${name}'.";

  # list of packages whose binaries are built in core, core-big
  # generated manually by inspecting ${core}/bin
  corePackages = [ "afm2pl" "aleph" "autosp" "axodraw2" "bibtex" "cjkutils"
    "ctie" "cweb" "detex" "dtl" "dvi2tty" "dvicopy" "dvidvi" "dviljk"
    "dviout-util" "dvipdfmx" "dvipos" "dvips" "fontware" "gregoriotex"
    "gsftopk" "hitex" "kpathsea" "lacheck" "lcdftypetools" "m-tx" "makeindex"
    "mfware" "musixtnt" "omegaware" "patgen" "pdftex" "pdftosrc" "pmx"
    "ps2eps" "ps2pk" "psutils"  "ptex" "seetexk" "synctex" "t1utils" "tex"
    "tex4ht" "texlive-scripts-extra" "texware" "tie" "tpic2pdftex" "ttfutils"
    "uptex" "velthuis" "vlna" "web" "xml2pmx" ];
  coreBigPackages = [ "metafont" "mflua" "metapost" "luatex" "luahbtex"
    "xetex" ] ++ lib.optional withLuaJIT "luajittex";
  binPackages = lib.getAttrs (corePackages ++ coreBigPackages) tlpdb;

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  common = {
    src = fetchurl {
      urls = [
        "http://ftp.math.utah.edu/pub/tex/historic/systems/texlive/${year}/texlive-${year}0321-source.tar.xz"
              "ftp://tug.ctan.org/pub/tex/historic/systems/texlive/${year}/texlive-${year}0321-source.tar.xz"
      ];
      hash = "sha256-X/o0heUessRJBJZFD8abnXvXy55TNX2S20vNT9YXm1Y=";
    };

    prePatch = ''
      for i in texk/kpathsea/mktex*; do
        sed -i '/^mydir=/d' "$i"
      done

      # ST_NLINK_TRICK causes kpathsea to treat folders with no real subfolders
      # as leaves, even if they contain symlinks to other folders; must be
      # disabled to work correctly with the nix store", see section 5.3.6
      # “Subdirectory expansion” of the kpathsea manual
      # http://mirrors.ctan.org/systems/doc/kpathsea/kpathsea.pdf for more
      # details
      sed -i '/^#define ST_NLINK_TRICK/d' texk/kpathsea/config.h
    '' +
    # when cross compiling, we must use himktables from PATH
    # (i.e. from buildPackages.texlive.bin.core.dev)
    lib.optionalString (!stdenv.buildPlatform.canExecute stdenv.hostPlatform)  ''
      sed -i 's|\./himktables|himktables|' texk/web2c/Makefile.in
    ''
;

    configureFlags = [
      "--with-banner-add=/nixos.org"
<<<<<<< HEAD
      "--disable-missing" # terminate if a requested program or feature must be
                          # disabled, e.g., due to missing libraries
      "--disable-native-texlive-build" # do not build for the TeX Live binary distribution
      "--enable-shared" # "--enable-cxx-runtime-hack" # static runtime
      "--enable-tex-synctex"
      "--disable-texlive" # do not build the texlive (TeX Live scripts) package
      "--disable-linked-scripts" # do not install the linked scripts
=======
      "--disable-missing" "--disable-native-texlive-build"
      "--enable-shared" # "--enable-cxx-runtime-hack" # static runtime
      "--enable-tex-synctex"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      "-C" # use configure cache to speed up
    ]
      ++ withSystemLibs [
      # see "from TL tree" vs. "Using installed"  in configure output
      "zziplib" "mpfr" "gmp"
      "pixman" "potrace" "gd" "freetype2" "libpng" "libpaper" "zlib"
<<<<<<< HEAD
    ] ++ lib.optional (stdenv.hostPlatform != stdenv.buildPlatform)
      "BUILDCC=${buildPackages.stdenv.cc.targetPrefix}cc";

    # move binaries to corresponding split outputs, based on content of texlive.tlpdb
    binToOutput = lib.listToAttrs
      (lib.concatMap
        (n: map (v: { name = v; value = builtins.replaceStrings [ "-" ] [ "_" ] n; }) binPackages.${n}.binfiles or [ ])
        (builtins.attrNames binPackages));

    moveBins = ''
      for bin in "$out/bin"/* ; do
        bin="''${bin##*/}"
        package="''${binToOutput[$bin]}"
        if [[ -n "$package" ]] ; then
          if [[ -z "''${!package}" ]] ; then
            echo "WARNING: missing output '$package' for binary '$bin', leaving in 'out'"
          else
            mkdir -p "''${!package}"/bin
            mv "$out/bin/$bin" "''${!package}"/bin/
          fi
        else
          echo "WARNING: no output known for binary '$bin', leaving in 'out'"
        fi
=======
    ];

    # clean broken links to stuff not built
    cleanBrokenLinks = ''
      for f in "$out"/bin/*; do
        if [[ ! -x "$f" ]]; then rm "$f"; fi
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      done
    '';
  };

  # RISC-V: https://github.com/LuaJIT/LuaJIT/issues/628
  withLuaJIT = !(stdenv.hostPlatform.isPower && stdenv.hostPlatform.is64bit) && !stdenv.hostPlatform.isRiscV;
in rec { # un-indented

<<<<<<< HEAD
=======
inherit (common) cleanBrokenLinks;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
texliveYear = year;


core = stdenv.mkDerivation rec {
  pname = "texlive-bin";
  inherit version;

<<<<<<< HEAD
  __structuredAttrs = true;

  inherit (common) binToOutput src prePatch;

  outputs = [ "out" "dev" "man" "info" ]
    ++ (builtins.map (builtins.replaceStrings [ "-" ] [ "_" ]) corePackages);

  nativeBuildInputs = [
    pkg-config
  ] ++ lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) (with texlive.bin.core; [
    # configure: error: tangle was not found but is required when cross-compiling.
    # dev (himktables) is used when building hitex to generate the additional source file hitables.c
    web/*tangle*/ cweb/*ctangle*/ omegaware/*otangle*/ tie/*tie*/ # see "Building TeX Live" 6.4.2 Cross problems
    dev/*himktables*/
  ]);
=======
  inherit (common) src prePatch;

  outputs = [ "out" "doc" "dev" ];

  nativeBuildInputs = [
    pkg-config
  ] ++ lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    # configure: error: tangle was not found but is required when cross-compiling.
    # dev (himktables) is used when building hitex to generate the additional source file hitables.c
    texlive.bin.core
    texlive.bin.core.dev
  ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  buildInputs = [
    /*teckit*/ zziplib mpfr gmp
    pixman gd freetype libpng libpaper zlib
    perl
  ];

<<<<<<< HEAD
  patches = [
    # Fix implicit `int` on `main`, which results in an error when building with clang 16.
    # This is fixed upstream and can be dropped with the 2023 release.
    ./fix-implicit-int.patch
  ];

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  hardeningDisable = [ "format" ];

  preConfigure = ''
    rm -r libs/{cairo,freetype2,gd,gmp,graphite2,harfbuzz,icu,libpaper,libpng} \
<<<<<<< HEAD
      libs/{lua53,luajit,mpfr,pixman,pplib,teckit,zlib,zziplib} \
      texk/{bibtex-x,chktex,dvipng,dvisvgm,upmendex,xdvik} \
      utils/{asymptote,texdoctk,xindy,xpdfopen}
=======
      libs/{lua53,luajit,mpfr,pixman,zlib,zziplib}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    mkdir WorkDir
    cd WorkDir
  '';
  configureScript = "../configure";

  depsBuildBuild = [ buildPackages.stdenv.cc ];

  configureFlags = common.configureFlags
<<<<<<< HEAD
=======
    ++ lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [ "BUILDCC=${buildPackages.stdenv.cc.targetPrefix}cc" ]
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    ++ [ "--without-x" ] # disable xdvik and xpdfopen
    ++ map (what: "--disable-${what}") [
      "chktex"
      "dvisvgm" "dvipng" # ghostscript dependency
      "luatex" "luajittex" "luahbtex" "luajithbtex"
      "mp" "pmp" "upmp" "mf" "mflua" "mfluajit" # cairo would bring in X and more
      "xetex" "bibtexu" "bibtex8" "bibtex-x" "upmendex" # ICU isn't small
    ];

  enableParallelBuilding = true;

  doCheck = false; # triptest fails, likely due to missing TEXMF tree
  preCheck = "patchShebangs ../texk/web2c";

<<<<<<< HEAD
  installTargets = [ "install" ];

  # TODO: perhaps improve texmf.cnf search locations
  postInstall =
       /* remove redundant texmf-dist (content provided by TeX Live packages) */
  ''
    rm -fr "$out"/share/texmf-dist
  '' + /* install himktables in separate output for use in cross compilation */ ''
     mkdir -p $dev/bin
     cp texk/web2c/.libs/himktables $dev/bin/himktables
  '' + common.moveBins;

=======
  installTargets = [ "install" "texlinks" ];

  # TODO: perhaps improve texmf.cnf search locations
  postInstall =
    /* links format -> engine will be regenerated in texlive.combine
       note: for unlinking, the texlinks patch is irrelevant, so we use
       the included texlinks.sh to avoid the dependency on bin.texlinks */ ''
    PATH="$out/bin:$PATH" sh ../texk/texlive/linked_scripts/texlive-extra/texlinks.sh --cnffile "$out/share/texmf-dist/web2c/fmtutil.cnf" --unlink "$out/bin"
  '' + /* a few texmf-dist files are useful; take the rest from pkgs */ ''
    mv "$out/share/texmf-dist/web2c/texmf.cnf" .
    rm -r "$out/share/texmf-dist"
    mkdir -p "$out"/share/texmf-dist/{web2c,scripts/texlive/TeXLive}
    mv ./texmf.cnf "$out/share/texmf-dist/web2c/"
    cp ../texk/tests/TeXLive/*.pm "$out/share/texmf-dist/scripts/texlive/TeXLive/"
    cp ../texk/texlive/linked_scripts/scripts.lst "$out/share/texmf-dist/scripts/texlive/"
  '' +
    (let extraScripts =
          ''
            tex4ht/ht.sh
            tex4ht/htcontext.sh
            tex4ht/htcopy.pl
            tex4ht/htlatex.sh
            tex4ht/htmex.sh
            tex4ht/htmove.pl
            tex4ht/httex.sh
            tex4ht/httexi.sh
            tex4ht/htxelatex.sh
            tex4ht/htxetex.sh
            tex4ht/mk4ht.pl
            tex4ht/xhlatex.sh
          '';
      in
        ''
          echo -e 'texmf_scripts="$texmf_scripts\n${extraScripts}"' \
            >> "$out/share/texmf-dist/scripts/texlive/scripts.lst"
        '')
  + /* doc location identical with individual TeX pkgs */ ''
    mkdir -p "$doc/doc"
    mv "$out"/share/{man,info} "$doc"/doc
  '' + /* remove manpages for utils that live in texlive.texlive-scripts to avoid a conflict in buildEnv */ ''
    (cd "$doc"/doc/man/man1; rm {fmtutil-sys.1,fmtutil.1,mktexfmt.1,mktexmf.1,mktexpk.1,mktextfm.1,texhash.1,updmap-sys.1,updmap.1})
  '' + /* install himktables in separate output for use in cross compilation */ ''
     mkdir -p $dev/bin
     cp texk/web2c/.libs/himktables $dev/bin/himktables
  '' + cleanBrokenLinks;

  setupHook = ./setup-hook.sh; # TODO: maybe texmf-nix -> texmf (and all references)
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  passthru = { inherit version buildInputs; };

  meta = with lib; {
    description = "Basic binaries for TeX Live";
    homepage    = "http://www.tug.org/texlive";
    license     = lib.licenses.gpl2;
    maintainers = with maintainers; [ veprbl lovek323 raskin jwiegley ];
    platforms   = platforms.all;
  };
};


<<<<<<< HEAD
inherit (core-big) metafont mflua metapost luatex luahbtex xetex;
luajittex = core.big.luajittex or null;
core-big = stdenv.mkDerivation {
  pname = "texlive-core-big.bin";
  inherit version;

  __structuredAttrs = true;

  inherit (common) binToOutput src prePatch;
=======
inherit (core-big) metafont mflua metapost luatex luahbtex luajittex xetex;
core-big = stdenv.mkDerivation { #TODO: upmendex
  pname = "texlive-core-big.bin";
  inherit version;

  inherit (common) src prePatch;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  patches = [
    # improves reproducibility of fmt files. This patch has been proposed upstream,
    # but they are considering some other approaches as well. This is fairly
    # conservative so we can safely apply it until they make a decision
    # https://mailman.ntg.nl/pipermail/dev-luatex/2022-April/006650.html
    (fetchpatch {
      name = "reproducible_exception_strings.patch";
      url = "https://bugs.debian.org/cgi-bin/bugreport.cgi?att=1;bug=1009196;filename=reproducible_exception_strings.patch;msg=5";
      sha256 = "sha256-RNZoEeTcWnrLaltcYrhNIORh42fFdwMzBfxMRWVurbk=";
    })
<<<<<<< HEAD
    # fixes a security-issue in luatex that allows arbitrary code execution even with shell-escape disabled, see https://tug.org/~mseven/luatex.html
    (fetchpatch {
      name = "CVE-2023-32700.patch";
      url = "https://tug.org/~mseven/luatex-files/2022/patch";
      hash = "sha256-o9ENLc1ZIIOMX6MdwpBIgrR/Jdw6tYLmAyzW8i/FUbY=";
      excludes = [  "build.sh" ];
      stripLen = 1;
    })
    # Fixes texluajitc crashes on aarch64, backport of the upstream fix
    # https://github.com/LuaJIT/LuaJIT/commit/e9af1abec542e6f9851ff2368e7f196b6382a44c
    # to the version vendored by texlive (2.1.0-beta3)
    (fetchpatch {
      name = "luajit-fix-aarch64-linux.patch";
      url = "https://raw.githubusercontent.com/void-linux/void-packages/master/srcpkgs/LuaJIT/patches/e9af1abec542e6f9851ff2368e7f196b6382a44c.patch";
      hash = "sha256-ysSZmfpfCFMukfHmIqwofAZux1e2kEq/37lfqp7HoWo=";
      stripLen = 1;
      extraPrefix = "libs/luajit/LuaJIT-src/";
    })
    # Fix implicit `int` on `main`, which results in an error when building with clang 16.
    # This is fixed upstream and can be dropped with the 2023 release.
    ./fix-implicit-int.patch
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  hardeningDisable = [ "format" ];

  inherit (core) nativeBuildInputs depsBuildBuild;
  buildInputs = core.buildInputs ++ [ core cairo harfbuzz icu graphite2 libX11 ];

<<<<<<< HEAD
  /* deleting the unused packages speeds up configure by a considerable margin
     and ensures we do not rebuild existing libraries by mistake */
  preConfigure = ''
    rm -r libs/{cairo,freetype2,gd,gmp,graphite2,harfbuzz,icu,libpaper,libpng} \
      libs/{mpfr,pixman,xpdf,zlib,zziplib} \
      texk/{afm2pl,bibtex-x,chktex,cjkutils,detex,dtl,dvi2tty,dvidvi,dviljk,dviout-util} \
      texk/{dvipdfm-x,dvipng,dvipos,dvipsk,dvisvgm,gregorio,gsftopk,kpathsea} \
      texk/{lcdf-typetools,makeindexk,makejvf,mendexk,musixtnt,ps2pk,psutils,ptexenc} \
      texk/{seetexk,tex4htk,texlive,ttf2pk2,ttfdump,xdvik} \
      utils/{asymptote,autosp,axodraw2,devnag,lacheck,m-tx,pmx,ps2eps,t1utils,texdoctk} \
      utils/{tpic2pdftex,vlna,xindy,xml2pmx,xpdfopen}
    mkdir WorkDir
    cd WorkDir
  '';

  configureFlags = common.configureFlags
    ++ withSystemLibs [ "kpathsea" "ptexenc" "cairo" "harfbuzz" "icu" "graphite2" ]
    ++ map (prog: "--disable-${prog}") # don't build things we already have
      # list from texk/web2c/configure
      ([ "tex" "ptex" "eptex" "uptex" "euptex" "aleph" "hitex" "pdftex"
        "web-progs" "synctex"
      ] ++ lib.optionals (!withLuaJIT) [ "luajittex" "luajithbtex" "mfluajit" ])
    /* disable all packages, re-enable upmendex, web2c packages */
    ++ [ "--disable-all-pkgs" "--enable-upmendex" "--enable-web2c" ]
    /* kpathsea requires specifying the kpathsea location manually */
    ++ [ "--with-kpathsea-includes=${core.dev}/include" ];

  configureScript = "../configure";

=======
  configureFlags = common.configureFlags
    ++ withSystemLibs [ "kpathsea" "ptexenc" "cairo" "harfbuzz" "icu" "graphite2" ]
    ++ map (prog: "--disable-${prog}") # don't build things we already have
      ([ "tex" "ptex" "eptex" "uptex" "euptex" "aleph" "pdftex"
        "web-progs" "synctex"
      ] ++ lib.optionals (!withLuaJIT) [ "luajittex" "luajithbtex" "mfluajit" ]);

  configureScript = ":";

  # we use static libtexlua, because it's only used by a single binary
  postConfigure = let
    luajit = lib.optionalString withLuaJIT ",luajit";
  in
  lib.optionalString (stdenv.hostPlatform != stdenv.buildPlatform)
  # without this, the native builds attempt to use the binary
  # ${target-triple}-gcc, but we need to use the wrapper script.
  ''
    export BUILDCC=${buildPackages.stdenv.cc}/bin/cc
  ''
  +
  ''
    mkdir ./WorkDir && cd ./WorkDir
    for path in libs/{pplib,teckit,lua53${luajit}} texk/web2c; do
      (
        if [[ "$path" =~ "libs/lua" ]]; then
          extraConfig="--enable-static --disable-shared"
        else
          extraConfig=""
        fi
  '' + lib.optionalString (!stdenv.buildPlatform.canExecute stdenv.hostPlatform)
    # results of the tests performed by the configure scripts are
    # toolchain-dependent, so native components and cross components cannot use
    # the same cached test results.
    # Disable the caching for components with native subcomponents.
  ''
        if [[ "$path" =~ "libs/luajit" ]] || [[ "$path" =~ "texk/web2c" ]]; then
          extraConfig="$extraConfig --cache-file=/dev/null"
        fi
  ''
  +
  ''
        mkdir -p "$path" && cd "$path"
        "../../../$path/configure" $configureFlags $extraConfig

        if [[ "$path" =~ "libs/luajit" ]] || [[ "$path" =~ "libs/pplib" ]]; then
          # ../../../texk/web2c/mfluadir/luapeg/lpeg.h:29:10: fatal error: 'lua.h' file not found
          # ../../../texk/web2c/luatexdir/luamd5/md5lib.c:197:10: fatal error: 'utilsha.h' file not found
          make ''${enableParallelBuilding:+-j''${NIX_BUILD_CORES}}
        fi
      )
    done
  '';

  preBuild = "cd texk/web2c";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  enableParallelBuilding = true;

  doCheck = false; # fails

<<<<<<< HEAD
  outputs = [ "out" "dev" "man" "info" ]
    ++ (builtins.map (builtins.replaceStrings [ "-" ] [ "_" ]) coreBigPackages)
    # some outputs of metapost, omegaware are for ptex/uptex
    ++ [ "ptex" "uptex" ]
    # unavoidable duplicates from core
    ++ [ "ctie" "cweb" "omegaware" "texlive_scripts_extra" "tie" "web" ];
  postInstall = common.moveBins;
=======
  # now distribute stuff into outputs, roughly as upstream TL
  # (uninteresting stuff remains in $out, typically duplicates from `core`)
  outputs = [
    "out"
    "metafont"
    "mflua"
    "metapost"
    "luatex"
    "luahbtex"
    "luajittex"
    "xetex"
  ];
  postInstall = ''
    for output in $(getAllOutputNames); do
      mkdir -p "''${!output}/bin"
    done

    mv "$out/bin"/{inimf,mf,mf-nowin} "$metafont/bin/"
    mv "$out/bin"/mflua{,-nowin} "$mflua/bin/"
    mv "$out/bin"/{*tomp,mfplain,*mpost} "$metapost/bin/"
    mv "$out/bin"/{luatex,texlua,texluac} "$luatex/bin/"
    mv "$out/bin"/luahbtex "$luahbtex/bin/"
    mv "$out/bin"/xetex "$xetex/bin/"
  '' + lib.optionalString withLuaJIT ''
    mv "$out/bin"/mfluajit{,-nowin} "$mflua/bin/"
    mv "$out/bin"/{luajittex,luajithbtex,texluajit,texluajitc} "$luajittex/bin/"
  '' ;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
};


chktex = stdenv.mkDerivation {
  pname = "texlive-chktex.bin";
  inherit version;

  inherit (common) src;

  nativeBuildInputs = [ pkg-config ];
<<<<<<< HEAD
  # perl used in shebang of script bin/deweb
  buildInputs = [ core/*kpathsea*/ perl ];
=======
  buildInputs = [ core/*kpathsea*/ ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  preConfigure = "cd texk/chktex";

  configureFlags = common.configureFlags
    ++ [ "--with-system-kpathsea" ];

  enableParallelBuilding = true;
};


dvisvgm = stdenv.mkDerivation rec {
  pname = "texlive-dvisvgm.bin";
  inherit version;

  inherit (common) src;

  preConfigure = "cd texk/dvisvgm";

  configureFlags = common.configureFlags
    ++ [ "--with-system-kpathsea" ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ core brotli ghostscript zlib freetype woff2 potrace xxHash ];

  enableParallelBuilding = true;
};


dvipng = stdenv.mkDerivation {
  pname = "texlive-dvipng.bin";
  inherit version;

  inherit (common) src;

  nativeBuildInputs = [ perl pkg-config makeWrapper ];
  buildInputs = [ core/*kpathsea*/ zlib libpng freetype gd ghostscript ];

  preConfigure = ''
    cd texk/dvipng
    patchShebangs doc/texi2pod.pl
  '';

  configureFlags = common.configureFlags
    ++ [ "--with-system-kpathsea" "--with-gs=yes" "--disable-debug" ];

  GS="${ghostscript}/bin/gs";

  enableParallelBuilding = true;
};

<<<<<<< HEAD
=======

latexindent = perlPackages.buildPerlPackage rec {
  pname = "latexindent";
  inherit (src) version;

  src = lib.head (builtins.filter (p: p.tlType == "run") texlive.latexindent.pkgs);

  outputs = [ "out" ];

  nativeBuildInputs = lib.optional stdenv.isDarwin shortenPerlShebang;
  propagatedBuildInputs = with perlPackages; [ FileHomeDir LogDispatch LogLog4perl UnicodeLineBreak YAMLTiny ];

  postPatch = ''
    substituteInPlace scripts/latexindent/LatexIndent/GetYamlSettings.pm \
      --replace '$FindBin::RealBin/defaultSettings.yaml' ${src}/scripts/latexindent/defaultSettings.yaml
  '';

  # Dirty hack to apply perlFlags, but do no build
  preConfigure = ''
    touch Makefile.PL
  '';
  dontBuild = true;
  installPhase = ''
    install -D ./scripts/latexindent/latexindent.pl "$out"/bin/latexindent
    mkdir -p "$out"/${perl.libPrefix}
    cp -r ./scripts/latexindent/LatexIndent "$out"/${perl.libPrefix}/
  '' + lib.optionalString stdenv.isDarwin ''
    shortenPerlShebang "$out"/bin/latexindent
  '';
};


>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
pygmentex = python3Packages.buildPythonApplication rec {
  pname = "pygmentex";
  inherit (src) version;
  format = "other";

<<<<<<< HEAD
  src = assertFixedHash pname (lib.head (builtins.filter (p: p.tlType == "run") texlive.pygmentex.pkgs));
=======
  src = lib.head (builtins.filter (p: p.tlType == "run") texlive.pygmentex.pkgs);
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  propagatedBuildInputs = with python3Packages; [ pygments chardet ];

  dontBuild = true;

  doCheck = false;

  installPhase = ''
    runHook preInstall

    install -D ./scripts/pygmentex/pygmentex.py "$out"/bin/pygmentex

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://www.ctan.org/pkg/pygmentex";
    description = "Auxiliary tool for typesetting code listings in LaTeX documents using Pygments";
    longDescription = ''
      PygmenTeX is a Python-based LaTeX package that can be used for
      typesetting code listings in a LaTeX document using Pygments.

      Pygments is a generic syntax highlighter for general use in all kinds of
      software such as forum systems, wikis or other applications that need to
      prettify source code.
    '';
    license = licenses.lppl13c;
    maintainers = with maintainers; [ romildo ];
  };
};

<<<<<<< HEAD
inherit asymptote;

inherit biber;
inherit biber-ms;
=======

texlinks = stdenv.mkDerivation rec {
  name = "texlinks";

  src = lib.head (builtins.filter (p: p.tlType == "run") texlive.texlive-scripts-extra.pkgs);

  dontBuild = true;
  doCheck = false;

  installPhase = ''
    runHook preInstall

    # Patch texlinks.sh back to 2015 version;
    # otherwise some bin/ links break, e.g. xe(la)tex.
    patch --verbose -R scripts/texlive-extra/texlinks.sh < '${./texlinks.diff}'
    install -Dm555 scripts/texlive-extra/texlinks.sh "$out"/bin/texlinks

    runHook postInstall
  '';
};


inherit biber;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
bibtexu = bibtex8;
bibtex8 = stdenv.mkDerivation {
  pname = "texlive-bibtex-x.bin";
  inherit version;

  inherit (common) src;

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ core/*kpathsea*/ icu ];

  preConfigure = "cd texk/bibtex-x";

  configureFlags = common.configureFlags
    ++ [ "--with-system-kpathsea" "--with-system-icu" ];

  enableParallelBuilding = true;
};


xdvi = stdenv.mkDerivation {
  pname = "texlive-xdvi.bin";
  inherit version;

  inherit (common) src;

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ core/*kpathsea*/ freetype ghostscript ]
    ++ (with xorg; [ libX11 libXaw libXi libXpm libXmu libXaw libXext libXfixes ]);

  preConfigure = "cd texk/xdvik";

  configureFlags = common.configureFlags
    ++ [ "--with-system-kpathsea" "--with-system-libgs" ];

  enableParallelBuilding = true;

  postInstall = ''
    substituteInPlace "$out/bin/xdvi" \
      --replace "exec xdvi-xaw" "exec '$out/bin/xdvi-xaw'"
  '';
  # TODO: it's suspicious that mktexpk generates fonts into ~/.texlive2014
};

<<<<<<< HEAD
xpdfopen = stdenv.mkDerivation {
  pname = "texlive-xpdfopen.bin";
  inherit (lib.head texlive.xpdfopen.pkgs) version;

  inherit (common) src;

  buildInputs = [ libX11 ];

  preConfigure = "cd utils/xpdfopen";

  enableParallelBuilding = true;
};

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
} # un-indented

// lib.optionalAttrs (!clisp.meta.broken) # broken on aarch64 and darwin (#20062)
{

xindy = stdenv.mkDerivation {
  pname = "texlive-xindy.bin";
  inherit version;

  inherit (common) src;

  # If unset, xindy will try to mkdir /homeless-shelter
  HOME = ".";

  prePatch = "cd utils/xindy";
  # hardcode clisp location
  postPatch = ''
    substituteInPlace xindy-*/user-commands/xindy.in \
      --replace "our \$clisp = ( \$is_windows ? 'clisp.exe' : 'clisp' ) ;" \
                "our \$clisp = '$(type -P clisp)';"
  '';

  nativeBuildInputs = [
    pkg-config perl
    (texlive.combine { inherit (texlive) scheme-basic cyrillic ec; })
  ];
  buildInputs = [ clisp libiconv perl ];

  configureFlags = [ "--with-clisp-runtime=system" "--disable-xindy-docs" ];

  preInstall = ''mkdir -p "$out/bin" '';
  # fixup various file-location errors of: lib/xindy/{xindy.mem,modules/}
  postInstall = ''
    mkdir -p "$out/lib/xindy"
    mv "$out"/{bin/xindy.mem,lib/xindy/}
    ln -s ../../share/texmf-dist/xindy/modules "$out/lib/xindy/"
  '';
};

}
