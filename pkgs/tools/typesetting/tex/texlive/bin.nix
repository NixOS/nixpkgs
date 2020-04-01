{ stdenv, fetchurl, fetchpatch, patchutils
, texlive
, zlib, libiconv, libpng, libX11
, freetype, gd, libXaw, icu, ghostscript, libXpm, libXmu, libXext
, perl, perlPackages, python2Packages, pkgconfig, autoreconfHook
, poppler, libpaper, graphite2, zziplib, harfbuzz, potrace, gmp, mpfr
, cairo, pixman, xorg, clisp, biber, xxHash
, makeWrapper, shortenPerlShebang
}:

# Useful resource covering build options:
# http://tug.org/texlive/doc/tlbuild.html

let
  withSystemLibs = map (libname: "--with-system-${libname}");

  year = "2019";
  version = year; # keep names simple for now

  common = {
    src = fetchurl {
      urls = [
        "http://ftp.math.utah.edu/pub/tex/historic/systems/texlive/${year}/texlive-${year}0410-source.tar.xz"
              "ftp://tug.ctan.org/pub/tex/historic/systems/texlive/${year}/texlive-${year}0410-source.tar.xz"
      ];
      sha256 = "1dfps39q6bdr1zsbp9p74mvalmy3bycihv19sb9c6kg30kprz8nj";
    };

    patches = [
    ];

    postPatch = let
      # The source compatible with Poppler ${popplerVersion} not yet available in TeXLive ${year}
      # so we need to use files introduced in https://www.tug.org/svn/texlive?view=revision&revision=52959
      popplerVersion = "0.83.0";
      pdftoepdf = let
        revert-pdfmajorversion = fetchpatch {
          name = "pdftoepdf-revert-pdfmajorversion.patch";
          url = "https://www.tug.org/svn/texlive/trunk/Build/source/texk/web2c/pdftexdir/pdftoepdf.cc?view=patch&r1=52953&r2=52952&pathrev=52953";
          sha256 = "19jiv5xbvnfdk8lj6yd6mdxgs8f313a4dwg8svjj90dd35kjcfh8";
          revert = true;
          postFetch = ''
            # The default file, changed by this patch, contains a branch for vendored Poppler
            # The version-specific file replaces the section with an error, so we need to drop that part from the patch.
            # Fortunately, there is not anything else in the patch after #else.
            sed '/ #else/q' $out > "$tmpfile"
            ${patchutils}/bin/recountdiff "$tmpfile" > "$out"
          '';
        };
      in fetchurl {
        name = "pdftoepdf-poppler${popplerVersion}.cc";
        url = "https://www.tug.org/svn/texlive/trunk/Build/source/texk/web2c/pdftexdir/pdftoepdf-poppler${popplerVersion}.cc?revision=52959&view=co";
        sha256 = "0pngvw1jgnm4cqskrzf5a3z8rj4ssl10007n3wbblj50hvvzjph3";
        postFetch = ''
          # The trunk added some extra arguments to certain functions so we need to revert that
          # https://www.tug.org/svn/texlive?view=revision&revision=52953
          patch $out < ${revert-pdfmajorversion}
        '';
      };
      pdftosrc = fetchurl {
        name = "pdftosrc-poppler${popplerVersion}.cc";
        url = "https://www.tug.org/svn/texlive/trunk/Build/source/texk/web2c/pdftexdir/pdftosrc-poppler${popplerVersion}.cc?revision=52959&view=co";
        sha256 = "0iq2cmwvf2lxy32sygrafwqgcwvvbdnvxm5l3mrg9cb2a1g06380";
      };
    in ''
      for i in texk/kpathsea/mktex*; do
        sed -i '/^mydir=/d' "$i"
      done
      cp -pv ${pdftoepdf} texk/web2c/pdftexdir/pdftoepdf.cc
      cp -pv ${pdftosrc} texk/web2c/pdftexdir/pdftosrc.cc

      # poppler 0.84 compat fixups, use 0.83 files otherwise
      patch -p1 -i ${./poppler84.patch}
    '';

    # remove when removing synctex-missing-header.patch
    preAutoreconf = "pushd texk/web2c";
    postAutoreconf = "popd";

    configureFlags = [
      "--with-banner-add=/NixOS.org"
      "--disable-missing" "--disable-native-texlive-build"
      "--enable-shared" # "--enable-cxx-runtime-hack" # static runtime
      "--enable-tex-synctex"
      "-C" # use configure cache to speed up
    ]
      ++ withSystemLibs [
      # see "from TL tree" vs. "Using installed"  in configure output
      "zziplib" "xpdf" "poppler" "mpfr" "gmp"
      "pixman" "potrace" "gd" "freetype2" "libpng" "libpaper" "zlib"
        # beware: xpdf means to use stuff from poppler :-/
    ];

    # clean broken links to stuff not built
    cleanBrokenLinks = ''
      for f in "$out"/bin/*; do
        if [[ ! -x "$f" ]]; then rm "$f"; fi
      done
    '';
  };
in rec { # un-indented

inherit (common) cleanBrokenLinks;
texliveYear = year;


core = stdenv.mkDerivation rec {
  pname = "texlive-bin";
  inherit version;

  inherit (common) src patches postPatch preAutoreconf postAutoreconf;

  outputs = [ "out" "doc" ];

  nativeBuildInputs = [ pkgconfig autoreconfHook ];
  buildInputs = [
    /*teckit*/ zziplib poppler mpfr gmp
    pixman gd freetype libpng libpaper zlib
    perl
  ];

  hardeningDisable = [ "format" ];

  preConfigure = ''
    rm -r libs/{cairo,freetype2,gd,gmp,graphite2,harfbuzz,icu,libpaper,libpng} \
      libs/{mpfr,pixman,poppler,xpdf,zlib,zziplib}
    mkdir WorkDir
    cd WorkDir
  '';
  configureScript = "../configure";

  configureFlags = common.configureFlags
    ++ [ "--without-x" ] # disable xdvik and xpdfopen
    ++ map (what: "--disable-${what}") ([
      "dvisvgm" "dvipng" # ghostscript dependency
      "luatex" "luajittex" "mp" "pmp" "upmp" "mf" # cairo would bring in X and more
      "xetex" "bibtexu" "bibtex8" "bibtex-x" "upmendex" # ICU isn't small
    ] ++ stdenv.lib.optional (stdenv.hostPlatform.isPower && stdenv.hostPlatform.is64bit) "mfluajit")
    ++ [ "--without-system-harfbuzz" "--without-system-icu" ] # bogus configure
    ;

  enableParallelBuilding = true;

  doCheck = false; # triptest fails, likely due to missing TEXMF tree
  preCheck = "patchShebangs ../texk/web2c";

  installTargets = [ "install" "texlinks" ];

  # TODO: perhaps improve texmf.cnf search locations
  postInstall = /* a few texmf-dist files are useful; take the rest from pkgs */ ''
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
  '' + cleanBrokenLinks;

  # needed for poppler and xpdf
  CXXFLAGS = stdenv.lib.optionalString stdenv.cc.isClang "-std=c++14";

  setupHook = ./setup-hook.sh; # TODO: maybe texmf-nix -> texmf (and all references)
  passthru = { inherit version buildInputs; };

  meta = with stdenv.lib; {
    description = "Basic binaries for TeX Live";
    homepage    = http://www.tug.org/texlive;
    license     = stdenv.lib.licenses.gpl2;
    maintainers = with maintainers; [ vcunat veprbl lovek323 raskin jwiegley ];
    platforms   = platforms.all;
  };
};


inherit (core-big) metafont metapost luatex xetex;
core-big = stdenv.mkDerivation { #TODO: upmendex
  pname = "texlive-core-big.bin";
  inherit version;

  inherit (common) src patches postPatch preAutoreconf postAutoreconf;

  hardeningDisable = [ "format" ];

  inherit (core) nativeBuildInputs;
  buildInputs = core.buildInputs ++ [ core cairo harfbuzz icu graphite2 libX11 ];

  configureFlags = common.configureFlags
    ++ withSystemLibs [ "kpathsea" "ptexenc" "cairo" "harfbuzz" "icu" "graphite2" ]
    ++ map (prog: "--disable-${prog}") # don't build things we already have
      [ "tex" "ptex" "eptex" "uptex" "euptex" "aleph" "pdftex"
        "web-progs" "synctex"
        # luajittex is mostly not needed, see:
        # http://tex.stackexchange.com/questions/97999/when-to-use-luajittex-in-favour-of-luatex
        "luajittex" "mfluajit"
      ];

  configureScript = ":";

  # we use static libtexlua, because it's only used by a single binary
  postConfigure = ''
    mkdir ./WorkDir && cd ./WorkDir
    for path in libs/{teckit,lua53} texk/web2c; do
      (
        if [[ "$path" =~ "libs/lua5" ]]; then
          extraConfig="--enable-static --disable-shared"
        else
          extraConfig=""
        fi

        mkdir -p "$path" && cd "$path"
        "../../../$path/configure" $configureFlags $extraConfig
      )
    done
  '';

  preBuild = "cd texk/web2c";
  enableParallelBuilding = true;

  doCheck = false; # fails

  # now distribute stuff into outputs, roughly as upstream TL
  # (uninteresting stuff remains in $out, typically duplicates from `core`)
  outputs = [ "out" "metafont" "metapost" "luatex" "xetex" ];
  postInstall = ''
    for output in $outputs; do
      mkdir -p "''${!output}/bin"
    done

    mv "$out/bin"/{inimf,mf,mf-nowin} "$metafont/bin/"
    mv "$out/bin"/{*tomp,mfplain,*mpost} "$metapost/bin/"
    mv "$out/bin"/{luatex,texlua*} "$luatex/bin/"
    mv "$out/bin"/xetex "$xetex/bin/"
  '';
};


dvisvgm = stdenv.mkDerivation {
  pname = "texlive-dvisvgm.bin";
  inherit version;

  inherit (common) src;

  patches = [
    # Fix for ghostscript>=9.27
    # Backport of
    # https://github.com/mgieseki/dvisvgm/commit/bc51951bc90b700c28ea018993bdb058e5271e9b
    ./dvisvgm-fix.patch

    # Needed for ghostscript>=9.50
    (fetchpatch {
      url = "https://github.com/mgieseki/dvisvgm/commit/7b93a9197b69305429183affd24fa40ee04a663a.patch";
      sha256 = "1gmj76ja9xng39wxckhs9q140abixgb8rkrcfv2cdgq786wm3vag";
      stripLen = 1;
      extraPrefix = "texk/dvisvgm/dvisvgm-src/";
    })
  ];

  nativeBuildInputs = [ pkgconfig ];
  # TODO: dvisvgm still uses vendored dependencies
  buildInputs = [ core/*kpathsea*/ ghostscript zlib freetype /*potrace xxHash*/ ];

  preConfigure = "cd texk/dvisvgm";

  # configure script has a bug: it refers to $HAVE_LIBGS but sets $have_libgs
  # TODO: remove for texlive 2020?
  HAVE_LIBGS = 1;

  configureFlags = common.configureFlags
    ++ [ "--with-system-kpathsea" ];

  enableParallelBuilding = true;
};


dvipng = stdenv.mkDerivation {
  pname = "texlive-dvipng.bin";
  inherit version;

  inherit (common) src;

  nativeBuildInputs = [ perl pkgconfig ];
  buildInputs = [ core/*kpathsea*/ zlib libpng freetype gd ghostscript makeWrapper ];

  patches = [
    (fetchpatch {
      url = "http://git.savannah.nongnu.org/cgit/dvipng.git/patch/?id=f3ff241827a587e3d39eda477041fd3280f5b245";
      sha256 = "1a0ixl9mga24p6xk8dy3v60yifvbzd27vs0hv8996rfkp8jqa7is";
      stripLen = 1;
      extraPrefix = "texk/dvipng/dvipng-src/";
    })
  ];

  preConfigure = ''
    cd texk/dvipng
    patchShebangs doc/texi2pod.pl
  '';

  configureFlags = common.configureFlags
    ++ [ "--with-system-kpathsea" "--with-gs=yes" "--disable-debug" ];

  enableParallelBuilding = true;

  # I didn't manage to hardcode gs location by configureFlags
  postInstall = ''
    wrapProgram "$out/bin/dvipng" --prefix PATH : '${ghostscript}/bin'
  '';
};


latexindent = perlPackages.buildPerlPackage rec {
  pname = "latexindent";
  inherit (src) version;

  src = stdenv.lib.head (builtins.filter (p: p.tlType == "run") texlive.latexindent.pkgs);

  outputs = [ "out" ];

  nativeBuildInputs = stdenv.lib.optional stdenv.isDarwin shortenPerlShebang;
  propagatedBuildInputs = with perlPackages; [ FileHomeDir LogDispatch LogLog4perl UnicodeLineBreak YAMLTiny ];

  postPatch = ''
    substituteInPlace scripts/latexindent/LatexIndent/GetYamlSettings.pm \
      --replace '$FindBin::RealBin/defaultSettings.yaml' ${src}/scripts/latexindent/defaultSettings.yaml
  '';

  # Dirty hack to apply perlFlags, but do no build
  preConfigure = ''
    touch Makefile.PL
  '';
  buildPhase = ":";
  installPhase = ''
    install -D ./scripts/latexindent/latexindent.pl "$out"/bin/latexindent
    mkdir -p "$out"/${perl.libPrefix}
    cp -r ./scripts/latexindent/LatexIndent "$out"/${perl.libPrefix}/
  '' + stdenv.lib.optionalString stdenv.isDarwin ''
    shortenPerlShebang "$out"/bin/latexindent
  '';
};


pygmentex = python2Packages.buildPythonApplication rec {
  pname = "pygmentex";
  inherit (src) version;

  src = stdenv.lib.head (builtins.filter (p: p.tlType == "run") texlive.pygmentex.pkgs);

  propagatedBuildInputs = with python2Packages; [ pygments chardet ];

  dontBuild = true;

  doCheck = false;

  installPhase = ''
    runHook preInstall

    install -D ./scripts/pygmentex/pygmentex.py "$out"/bin/pygmentex

    runHook postInstall
  '';

  meta = with stdenv.lib; {
    homepage = https://www.ctan.org/pkg/pygmentex;
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
  name = "texlinks.sh";

  src = stdenv.lib.head (builtins.filter (p: p.tlType == "run") texlive.texlive-scripts-extra.pkgs);

  dontBuild = true;
  doCheck = false;

  installPhase = ''
    runHook preInstall

    # Patch texlinks.sh back to 2015 version;
    # otherwise some bin/ links break, e.g. xe(la)tex.
    patch --verbose -R scripts/texlive-extra/texlinks.sh < '${./texlinks.diff}'
    install -Dm555 scripts/texlive-extra/texlinks.sh "$out"

    runHook postInstall
  '';
};


inherit biber;
bibtexu = bibtex8;
bibtex8 = stdenv.mkDerivation {
  pname = "texlive-bibtex-x.bin";
  inherit version;

  inherit (common) src;

  nativeBuildInputs = [ pkgconfig ];
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

  nativeBuildInputs = [ pkgconfig ];
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

// stdenv.lib.optionalAttrs (!stdenv.isDarwin) # see #20062
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
    pkgconfig perl
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
