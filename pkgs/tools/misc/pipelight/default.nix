{ lib, stdenv, fetchurl, bash, cabextract, curl, gnupg, libX11, libGLU, libGL, wine-staging }:

let
  wine_custom = wine-staging;

  mozillaPluginPath = "/lib/mozilla/plugins";


in stdenv.mkDerivation rec {

  version = "0.2.8.2";

  pname = "pipelight";

  src = fetchurl {
    url = "https://bitbucket.org/mmueller2012/pipelight/get/v${version}.tar.gz";
    sha256 = "1kyy6knkr42k34rs661r0f5sf6l1s2jdbphdg89n73ynijqmzjhk";
  };

  buildInputs = [ wine_custom libX11 libGLU libGL curl ];

  env.NIX_CFLAGS_COMPILE = toString [ "-fpermissive" ];

  patches = [
    ./pipelight.patch
    ./wine-6.13-new-args.patch
    # https://source.winehq.org/git/wine.git/commit/cf4a781e987a98a8d48610362a20a320c4a1016d
    # adds ControlMask as a static variable.
    ./wine-7.10-ControlMask.patch
  ];

  configurePhase = ''
    patchShebangs .
    ./configure \
      --prefix=$out \
      --moz-plugin-path=$out/${mozillaPluginPath} \
      --wine-path=${wine_custom} \
      --gpg-exec=${gnupg}/bin/gpg \
      --bash-interp=${bash}/bin/bash \
      --downloader=${curl.bin}/bin/curl
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
    license = with lib.licenses; [ mpl11 gpl2 lgpl21 ];
    description = "A wrapper for using Windows plugins in Linux browsers";
    maintainers = with lib.maintainers; [ skeidel ];
    platforms = [ "x86_64-linux" "i686-linux" ];
  };
}
