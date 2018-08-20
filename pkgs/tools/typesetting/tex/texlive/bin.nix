{ stdenv, fetchurl
, texlive
, zlib, libiconv, libpng, libX11
, freetype, gd, libXaw, icu, ghostscript, libXpm, libXmu, libXext
, perl, pkgconfig
, poppler, libpaper, graphite2, zziplib, harfbuzz, potrace, gmp, mpfr
, cairo, pixman, xorg, clisp, biber
, makeWrapper
}:

# Useful resource covering build options:
# http://tug.org/texlive/doc/tlbuild.html

let
  withSystemLibs = map (libname: "--with-system-${libname}");

  year = "2017";
  version = year; # keep names simple for now

  common = rec {
    src = fetchurl {
      url = # "ftp://tug.org/historic/systems/texlive/${year}/"
      #"http://lipa.ms.mff.cuni.cz/~cunav5am/nix/texlive-2016"
      # FIXME: a proper mirror, though tarballs.nixos.org saves this case ATM
      # http://146.185.144.154/texlive-2016
      # + "/texlive-${year}0523b-source.tar.xz";
        "http://ftp.math.utah.edu/pub/tex/historic/systems/texlive/${year}/texlive-${year}0524-source.tar.xz";
      sha256 = "1amjrxyasplv4alfwcxwnw4nrx7dz2ydmddkq16k6hg90i9njq81";
    };

    patches = [
      (fetchurl {
        name = "texlive-poppler-0.59.patch";
        url = https://git.archlinux.org/svntogit/packages.git/plain/trunk/texlive-poppler-0.59.patch?h=packages/texlive-bin&id=6308ec39bce2a4d735f6ff8a4e94473748d7b450;
        sha256 = "1c4ikq4kxw48bi3i33bzpabrjvbk01fwjr2lz20gkc9kv8l0bg3n";
      })
    ];

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
  name = "texlive-bin-${version}";

  inherit (common) src patches;

  outputs = [ "out" "doc" ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    /*teckit*/ zziplib poppler mpfr gmp
    pixman potrace gd freetype libpng libpaper zlib
    perl
  ];

  hardeningDisable = [ "format" ];

  postPatch = ''
    for i in texk/kpathsea/mktex*; do
      sed -i '/^mydir=/d' "$i"
    done
  '';

  preConfigure = ''
    rm -r libs/{cairo,freetype2,gd,gmp,graphite2,harfbuzz,icu,libpaper,libpng} \
      libs/{mpfr,pixman,poppler,potrace,xpdf,zlib,zziplib}
    mkdir WorkDir
    cd WorkDir
  '';
  configureScript = "../configure";

  configureFlags = common.configureFlags
    ++ [ "--without-x" ] # disable xdvik and xpdfopen
    ++ map (what: "--disable-${what}") [
      "dvisvgm" "dvipng" # ghostscript dependency
      "luatex" "luajittex" "mp" "pmp" "upmp" "mf" # cairo would bring in X and more
      "xetex" "bibtexu" "bibtex8" "bibtex-x" "upmendex" # ICU isn't small
    ]
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
  CXXFLAGS = stdenv.lib.optionalString stdenv.cc.isClang "-std=c++11";

  setupHook = ./setup-hook.sh; # TODO: maybe texmf-nix -> texmf (and all references)
  passthru = { inherit version buildInputs; };

  meta = with stdenv.lib; {
    description = "Basic binaries for TeX Live";
    homepage    = http://www.tug.org/texlive;
    license     = stdenv.lib.licenses.gpl2;
    maintainers = with maintainers; [ vcunat lovek323 raskin jwiegley ];
    platforms   = platforms.all;
  };
};


inherit (core-big) metafont metapost luatex xetex;
core-big = stdenv.mkDerivation { #TODO: upmendex
  name = "texlive-core-big.bin-${version}";

  inherit (common) src;

  hardeningDisable = [ "format" ];

  inherit (core) nativeBuildInputs;
  buildInputs = core.buildInputs ++ [ core cairo harfbuzz icu graphite2 ];

  configureFlags = common.configureFlags
    ++ withSystemLibs [ "kpathsea" "ptexenc" "cairo" "harfbuzz" "icu" "graphite2" ]
    ++ map (prog: "--disable-${prog}") # don't build things we already have
      [ "tex" "ptex" "eptex" "uptex" "euptex" "aleph" "pdftex"
        "web-progs" "synctex" "luajittex" "mfluajit" # luajittex is mostly not needed, see:
        # http://tex.stackexchange.com/questions/97999/when-to-use-luajittex-in-favour-of-luatex
      ];

  patches = common.patches ++ [ ./luatex-gcc7.patch ];

  configureScript = ":";

  # we use static libtexlua, because it's only used by a single binary
  postConfigure = ''
    mkdir ./WorkDir && cd ./WorkDir
    for path in libs/{teckit,lua52} texk/web2c; do
      (
        if [[ "$path" == "libs/lua52" ]]; then
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
  CXXFLAGS = "-std=c++11 -Wno-reserved-user-defined-literal"; # TODO: remove once texlive 2018 is out?
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
  name = "texlive-dvisvgm.bin-${version}";

  inherit (common) src;

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ core/*kpathsea*/ ghostscript zlib freetype potrace ];

  preConfigure = "cd texk/dvisvgm";

  configureFlags = common.configureFlags
    ++ [ "--with-system-kpathsea" "--with-system-libgs" ];

  enableParallelBuilding = true;
};


dvipng = stdenv.mkDerivation {
  name = "texlive-dvipng.bin-${version}";

  inherit (common) src;

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ core/*kpathsea*/ zlib libpng freetype gd ghostscript makeWrapper ];

  preConfigure = "cd texk/dvipng";

  configureFlags = common.configureFlags
    ++ [ "--with-system-kpathsea" "--with-gs=yes" "--disable-debug" ];

  enableParallelBuilding = true;

  # I didn't manage to hardcode gs location by configureFlags
  postInstall = ''
    wrapProgram "$out/bin/dvipng" --prefix PATH : '${ghostscript}/bin'
  '';
};


inherit biber;
bibtexu = bibtex8;
bibtex8 = stdenv.mkDerivation {
  name = "texlive-bibtex-x.bin-${version}";

  inherit (common) src;

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ core/*kpathsea*/ icu ];

  preConfigure = "cd texk/bibtex-x";

  configureFlags = common.configureFlags
    ++ [ "--with-system-kpathsea" "--with-system-icu" ];

  enableParallelBuilding = true;
};


xdvi = stdenv.mkDerivation {
  name = "texlive-xdvi.bin-${version}";

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
  name = "texlive-xindy.bin-${version}";

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
