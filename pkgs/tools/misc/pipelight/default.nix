{ stdenv, fetchurl, fetchgit, autoconf, automake, wineUnstable, perl, xlibs
  , gnupg, gcc48_multi, mesa, curl, bash, cacert, cabextract, utillinux, attr
  }:

let
  wine_patches_version = "1.7.30";
  wine_hash = "0v08w2av46y4wxrl8q4k9fhbi2cgawjaxclahqnpfw098bqcmxqh";

  wine_patches = fetchgit {
    url = "git://github.com/compholio/wine-compholio.git";
    rev = "refs/tags/v${wine_patches_version}";
    sha256 = "02i0bpxxiyxavlcd5qm7wv0q4bm9bxr3ng3w2k234ww7cyndm0ws";
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

  version = "0.2.7.3";

  name = "pipelight-${version}";

  src = fetchurl {
    url = "https://bitbucket.org/mmueller2012/pipelight/get/v${version}.tar.gz";
    sha256 = "0lifgs3aakyxfk6r2f2p27z0iqzgz1dinqfgwx3vdh3l93s8aifv";
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
