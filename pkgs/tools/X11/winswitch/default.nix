{ stdenv, fetchurl, buildPythonPackage, pythonPackages
, which, xpra, xmodmap }:

let
  base = buildPythonPackage rec {
    name = "winswitch-${version}";
    namePrefix = "";
    version = "0.12.16";

    src = fetchurl {
      url = "http://winswitch.org/src/${name}.src.tar.bz2";
      sha256 = "0ix122d7rgzdkk70f2q3sd7a4pvyaqsyxkw93pc4zkcg1xh9z3y8";
    };

    propagatedBuildInputs = with pythonPackages; [
      pygtk twisted pycrypto pyasn1 which xpra xmodmap
    ];

    patchPhase = ''
      sed -i -r -e 's|(PREFIX_DIR *= *).*|\1"'"$out"'"|'             \
                -e 's|(PREFIX_SEARCH_ORDER *= *).*|\1["'"$out"'"]|'  \
                -e 's|(ETC_SEARCH_ORDER *= *).*|\1["'"$out/etc"'"]|' \
                -e 's|(BIN_SEARCH_ORDER *= *).*|\1["'"$out/bin"'"]|' \
                winswitch/util/paths.py

      sed -i -e '/elif *LINUX:/,/distro_helper/{
        s/elif *LINUX:.*/else: name = "NixOS"/p
        /distro_helper/!d
      }' winswitch/util/distro_packaging_util.py
    '';

    preInstall = ''
      # see https://bitbucket.org/pypa/setuptools/issue/130/install_data-doesnt-respect-prefix
      python setup.py install_data --install-dir=$out --root=$out
      sed -i '/data_files = data_files/d' setup.py
    '';

    doCheck = false;

    meta.platforms = stdenv.lib.platforms.linux;
  };
in stdenv.lib.overrideDerivation base (b: {
  postFixup = b.postFixup + ''
    sed -i -e 's/\''${PATH:+:}\$PATH//g' "$out/bin"/*
  '';
})
