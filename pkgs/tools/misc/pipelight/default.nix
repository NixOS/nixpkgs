{ stdenv, fetchurl, fetchgit, autoconf, wineUnstable, perl, xlibs,
  gnupg, gcc48_multi, mesa, curl, bash, cacert, cabextract, utillinux}:

let
  wine = wineUnstable;

  wine_patches_version = wine.version;

  wine_patches = fetchgit {
    url = "git://github.com/compholio/wine-compholio.git";
    rev = "refs/tags/v${wine_patches_version}";
    sha256 = "16z8nkr3yczam52wrkaygkhgbs9y28jbi6qjxjijwnid7l88lvgn";
  };

  wine_custom =
    stdenv.lib.overrideDerivation wine (args: rec {
      src = null;
      srcs = [ args.src wine_patches ];
      sourceRoot = "./${wine.name}";
      buildInputs = args.buildInputs ++ [ autoconf perl utillinux ];
      postPatch = ''
        export wineDir=$(pwd)
        patchShebangs $wineDir/tools/
        chmod -R +rwx ../git-export/
        make -C ../git-export/patches DESTDIR=$wineDir install
      '';
    });

  mozillaPluginPath = "/lib/mozilla/plugins";

  fixupPatch = ./pipelight-fixup.patch;

in stdenv.mkDerivation rec {

  version = "0.2.7.2";

  name = "pipelight-${version}";

  src = fetchurl {
    url = "https://bitbucket.org/mmueller2012/pipelight/get/v${version}.tar.gz";
    sha256 = "02132151091f1f62d7409a537649efc86deb0eb4a323fd66907fc22947e2cfbd";
  };

  buildInputs = [ wine_custom xlibs.libX11 gcc48_multi mesa curl ];
  propagatedbuildInputs = [ curl cabextract ];

  patches = [ ./pipelight.patch ];

  configurePhase = ''
    ./configure \
      --prefix=$out \
      --moz-plugin-path=$out/${mozillaPluginPath} \
      --wine-path=${wine_custom} \
      --gpg-exec=${gnupg}/bin/gpg2 \
      --bash-interp=${bash}/bin/bash \
      --downloader=${curl}/bin/curl
      $configureFlags
  '';

  passthru = {
    mozillaPlugin = mozillaPluginPath;
  };

  postInstall = ''
    $out/bin/pipelight-plugin --update
    $out/bin/pipelight-plugin --create-mozilla-plugins
  '';

  preFixup = ''
    patch -d $out -p1 <${fixupPatch}
    substituteInPlace $out/share/pipelight/install-dependency \
      --replace cabextract ${cabextract}/bin/cabextract
  '';

  enableParallelBuilding = true;

  meta = {
    homepage = "http://pipelight.net/";
    licenses = with stdenv.lib.licenses; [ mpl11 gpl2 lgpl21 ];
    description = "A wrapper for using Windows plugins in Linux browsers";
    maintainers = with stdenv.lib.maintainers; [skeidel];
    platforms = with stdenv.lib.platforms; linux;
  };
}
