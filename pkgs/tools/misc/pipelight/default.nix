{ stdenv, fetchurl, fetchgit, autoconf, automake, wineUnstable, perl, xlibs
  , gnupg, gcc48_multi, mesa, curl, bash, cacert, cabextract, utillinux, attr
  }:

let
  wine_patches_version = "1.7.38";
  wine_hash = "1h3bsga9qzqkavf9wlv62ldl3a8mz7grr68nxv8vicmnglzfj7lq";

  wine_patches = fetchgit {
    url = "git://github.com/compholio/wine-compholio.git";
    rev = "refs/tags/v${wine_patches_version}";
    sha256 = "0lcagswy1lgqz6qlpf0ng7ksl2sbaqldrgnhf0n1278jj82rq80n";
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
        chmod u+w $wineDir/../${wine_patches.name}/debian/tools/
        patchShebangs $wineDir/../${wine_patches.name}/debian/tools/
        chmod -R +rwx ../${wine_patches.name}/
        make -C ../${wine_patches.name}/patches DESTDIR=$wineDir install
      '';
    });

  mozillaPluginPath = "/lib/mozilla/plugins";


in stdenv.mkDerivation rec {

  version = "0.2.8";

  name = "pipelight-${version}";

  src = fetchurl {
    url = "https://bitbucket.org/mmueller2012/pipelight/get/v${version}.tar.gz";
    sha256 = "1i440rf22fmd2w86dlm1mpi3nb7410rfczc0yldnhgsvp5p3sm5f";
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
    license = with stdenv.lib.licenses; [ mpl11 gpl2 lgpl21 ];
    description = "A wrapper for using Windows plugins in Linux browsers";
    maintainers = with stdenv.lib.maintainers; [skeidel];
    platforms = with stdenv.lib.platforms; linux;
  };
}
