{ lib, stdenv, fetchurl, fetchpatch, buildPackages
, texlive
, zlib, libiconv, libpng, libX11
, freetype, gd, libXaw, icu, ghostscript, libXpm, libXmu, libXext
, perl, perlPackages, python3Packages, pkg-config
, libpaper, graphite2, zziplib, harfbuzz, potrace, gmp, mpfr
, brotli, cairo, pixman, xorg, clisp, biber, woff2, xxHash
, makeWrapper, shortenPerlShebang
}:

# Useful resource covering build options:
# http://tug.org/texlive/doc/tlbuild.html

let
  withSystemLibs = map (libname: "--with-system-${libname}");

  year = "2022";
  version = year; # keep names simple for now

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
    '';

    configureFlags = [
      "--with-banner-add=/nixos.org"
      "--disable-missing" "--disable-native-texlive-build"
      "--enable-shared" # "--enable-cxx-runtime-hack" # static runtime
      "--enable-tex-synctex"
      "-C" # use configure cache to speed up
    ]
      ++ withSystemLibs [
      # see "from TL tree" vs. "Using installed"  in configure output
      "zziplib" "mpfr" "gmp"
      "pixman" "potrace" "gd" "freetype2" "libpng" "libpaper" "zlib"
    ];

    # clean broken links to stuff not built
    cleanBrokenLinks = ''
      for f in "$out"/bin/*; do
        if [[ ! -x "$f" ]]; then rm "$f"; fi
      done
    '';
  };

  withLuaJIT = !(stdenv.hostPlatform.isPower && stdenv.hostPlatform.is64bit);
in rec { # un-indented

inherit (common) cleanBrokenLinks;
texliveYear = year;


core = stdenv.mkDerivation rec {
  pname = "texlive-bin";
  inherit version;

  inherit (common) src prePatch;

  outputs = [ "out" "doc" ];

  nativeBuildInputs = [
    pkg-config
  ] ++ lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    # configure: error: tangle was not found but is required when cross-compiling.
    texlive.bin.core
  ];

  buildInputs = [
    /*teckit*/ zziplib mpfr gmp
    pixman gd freetype libpng libpaper zlib
    perl
  ];

  hardeningDisable = [ "format" ];

  preConfigure = ''
    rm -r libs/{cairo,freetype2,gd,gmp,graphite2,harfbuzz,icu,libpaper,libpng} \
      libs/{lua53,luajit,mpfr,pixman,zlib,zziplib}
    mkdir WorkDir
    cd WorkDir
  '';
  configureScript = "../configure";

  depsBuildBuild = [ buildPackages.stdenv.cc ];

  configureFlags = common.configureFlags
    ++ lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [ "BUILDCC=${buildPackages.stdenv.cc.targetPrefix}cc" ]
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

  installTargets = [ "install" "texlinks" ];

  # TODO: perhaps improve texmf.cnf search locations
  postInstall = /* links format -> engine will be regenerated in texlive.combine */ ''
    PATH="$out/bin:$PATH" ${buildPackages.texlive.bin.texlinks}/bin/texlinks --cnffile "$out/share/texmf-dist/web2c/fmtutil.cnf" --unlink "$out/bin"
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
  '' + cleanBrokenLinks;

  setupHook = ./setup-hook.sh; # TODO: maybe texmf-nix -> texmf (and all references)
  passthru = { inherit version buildInputs; };

  meta = with lib; {
    description = "Basic binaries for TeX Live";
    homepage    = "http://www.tug.org/texlive";
    license     = lib.licenses.gpl2;
    maintainers = with maintainers; [ veprbl lovek323 raskin jwiegley ];
    platforms   = platforms.all;
  };
};


inherit (core-big) metafont mflua metapost luatex luahbtex luajittex xetex;
core-big = stdenv.mkDerivation { #TODO: upmendex
  pname = "texlive-core-big.bin";
  inherit version;

  inherit (common) src prePatch;

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
  ];

  hardeningDisable = [ "format" ];

  inherit (core) nativeBuildInputs;
  buildInputs = core.buildInputs ++ [ core cairo harfbuzz icu graphite2 libX11 ];

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
  in ''
    mkdir ./WorkDir && cd ./WorkDir
    for path in libs/{pplib,teckit,lua53${luajit}} texk/web2c; do
      (
        if [[ "$path" =~ "libs/lua" ]]; then
          extraConfig="--enable-static --disable-shared"
        else
          extraConfig=""
        fi

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
  enableParallelBuilding = true;

  doCheck = false; # fails

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
};


chktex = stdenv.mkDerivation {
  pname = "texlive-chktex.bin";
  inherit version;

  inherit (common) src;

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ core/*kpathsea*/ ];

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


pygmentex = python3Packages.buildPythonApplication rec {
  pname = "pygmentex";
  inherit (src) version;
  format = "other";

  src = lib.head (builtins.filter (p: p.tlType == "run") texlive.pygmentex.pkgs);

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
  buildInputs = [ clisp libiconv ];

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
