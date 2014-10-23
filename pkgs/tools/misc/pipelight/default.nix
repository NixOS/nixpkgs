{ stdenv, fetchurl, fetchgit, autoconf, automake, wineUnstable, perl, xlibs
  , gnupg, gcc48_multi, mesa, curl, bash, cacert, cabextract, utillinux, attr
  }:

let
  wine_patches_version = "1.7.28";
  wine_hash = "04r3zk3dz2vzly2a4nqbcvppjs5iy3lq5ibx3wfrf877p5bz3hv7";

  wine_patches = fetchgit {
    url = "git://github.com/compholio/wine-compholio.git";
    rev = "refs/tags/v${wine_patches_version}";
    sha256 = "17f1wmxbx6ly1ws4p528ijf9b4yvmnmap5k7npw9icvkyaky5xi9";
  };

  wine_custom =
    stdenv.lib.overrideDerivation wineUnstable (args: rec {
      name = "wine-${wine_patches_version}";
      version = "${wine_patches_version}";
      src = null;
      srcs = [
	      (fetchurl {
                url = "mirror://sourceforge/wine/${name}.tar.bz2";
                sha256 = wine_hash;
	      })
	      wine_patches ];
      sourceRoot = "./${name}";
      buildInputs = args.buildInputs ++ [ 
        autoconf perl utillinux automake attr 
      ];
      nativeBuildInputs = args.nativeBuildInputs ++ [ 
        autoconf perl utillinux automake attr 
      ];
      postPatch = ''
        export wineDir=$(pwd)
        patchShebangs $wineDir/tools/
	chmod u+w $wineDir/../git-export/debian/tools/
        patchShebangs $wineDir/../git-export/debian/tools/
        chmod -R +rwx ../git-export/
        make -C ../git-export/patches DESTDIR=$wineDir install
      '';
    });

  mozillaPluginPath = "/lib/mozilla/plugins";


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
    patchShebangs . 
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
    wine = wine_custom;
  };

  postInstall = ''
    $out/bin/pipelight-plugin --create-mozilla-plugins
  '';

  preFixup = ''
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
