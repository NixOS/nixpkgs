{ pkgs }:

with pkgs;

# emscripten toolchain abstraction for nix
# https://github.com/NixOS/nixpkgs/pull/16208

rec {
  json_c = (pkgs.json_c.override {
    stdenv = pkgs.emscriptenStdenv;
  }).overrideAttrs
    (old: {
      nativeBuildInputs = [ pkg-config cmake ];
      propagatedBuildInputs = [ zlib ];
      configurePhase = ''
        HOME=$TMPDIR
        mkdir -p .emscriptencache
        export EM_CACHE=$(pwd)/.emscriptencache
        emcmake cmake . $cmakeFlags -DCMAKE_INSTALL_PREFIX=$out -DCMAKE_INSTALL_INCLUDEDIR=$dev/include
      '';
      checkPhase = ''
        echo "================= testing json_c using node ================="

        echo "Compiling a custom test"
        set -x
        emcc -O2 -s EMULATE_FUNCTION_POINTER_CASTS=1 tests/test1.c \
          `pkg-config zlib --cflags` \
          `pkg-config zlib --libs` \
          -I . \
          libjson-c.a \
          -o ./test1.js

        echo "Using node to execute the test which basically outputs an error on stderr which we grep for"
        ${pkgs.nodejs}/bin/node ./test1.js

        set +x
        if [ $? -ne 0 ]; then
          echo "test1.js execution failed -> unit test failed, please fix"
          exit 1;
        else
          echo "test1.js execution seems to work! very good."
        fi
        echo "================= /testing json_c using node ================="
      '';
    });

  libxml2 = (pkgs.libxml2.override {
    stdenv = emscriptenStdenv;
    pythonSupport = false;
  }).overrideAttrs
    (old: {
      propagatedBuildInputs = [ zlib ];
      nativeBuildInputs = (old.nativeBuildInputs or []) ++ [ pkg-config ];

      # just override it with nothing so it does not fail
      autoreconfPhase = "echo autoreconfPhase not used...";
      configurePhase = ''
        HOME=$TMPDIR
        mkdir -p .emscriptencache
        export EM_CACHE=$(pwd)/.emscriptencache
        emconfigure ./configure --prefix=$out --without-python
      '';
      checkPhase = ''
        echo "================= testing libxml2 using node ================="

        echo "Compiling a custom test"
        set -x
        emcc -O2 -s EMULATE_FUNCTION_POINTER_CASTS=1 xmllint.o \
        ./.libs/${
          if pkgs.stdenv.hostPlatform.isDarwin then "libxml2.dylib" else "libxml2.a"
        } `pkg-config zlib --cflags` `pkg-config zlib --libs` -o ./xmllint.test.js \
        --embed-file ./test/xmlid/id_err1.xml

        echo "Using node to execute the test which basically outputs an error on stderr which we grep for"
        ${pkgs.nodejs}/bin/node ./xmllint.test.js --noout test/xmlid/id_err1.xml 2>&1 | grep 0bar

        set +x
        if [ $? -ne 0 ]; then
          echo "xmllint unit test failed, please fix this package"
          exit 1;
        else
          echo "since there is no stupid text containing 'foo xml:id' it seems to work! very good."
        fi
        echo "================= /testing libxml2 using node ================="
      '';
    });

  xmlmirror = pkgs.buildEmscriptenPackage rec {
    pname = "xmlmirror";
    version = "unstable-2016-06-05";

    buildInputs = [ libtool gnumake libxml2 nodejs openjdk json_c ];
    nativeBuildInputs = [ pkg-config zlib autoconf automake ];

    src = pkgs.fetchgit {
      url = "https://gitlab.com/odfplugfest/xmlmirror.git";
      rev = "4fd7e86f7c9526b8f4c1733e5c8b45175860a8fd";
      sha256 = "1jasdqnbdnb83wbcnyrp32f36w3xwhwp0wq8lwwmhqagxrij1r4b";
    };

    configurePhase = ''
      rm -f fastXmlLint.js*
      # a fix for ERROR:root:For asm.js, TOTAL_MEMORY must be a multiple of 16MB, was 234217728
      # https://gitlab.com/odfplugfest/xmlmirror/issues/8
      sed -e "s/TOTAL_MEMORY=234217728/TOTAL_MEMORY=268435456/g" -i Makefile.emEnv
      # https://github.com/kripken/emscripten/issues/6344
      # https://gitlab.com/odfplugfest/xmlmirror/issues/9
      sed -e "s/\$(JSONC_LDFLAGS) \$(ZLIB_LDFLAGS) \$(LIBXML20_LDFLAGS)/\$(JSONC_LDFLAGS) \$(LIBXML20_LDFLAGS) \$(ZLIB_LDFLAGS) /g" -i Makefile.emEnv
      # https://gitlab.com/odfplugfest/xmlmirror/issues/11
      sed -e "s/-o fastXmlLint.js/-s EXTRA_EXPORTED_RUNTIME_METHODS='[\"ccall\", \"cwrap\"]' -o fastXmlLint.js/g" -i Makefile.emEnv
      mkdir -p .emscriptencache
      export EM_CACHE=$(pwd)/.emscriptencache
    '';

    buildPhase = ''
      HOME=$TMPDIR
      make -f Makefile.emEnv
    '';

    outputs = [ "out" "doc" ];

    installPhase = ''
      mkdir -p $out/share
      mkdir -p $doc/share/${pname}

      cp Demo* $out/share
      cp -R codemirror-5.12 $out/share
      cp fastXmlLint.js* $out/share
      cp *.xsd $out/share
      cp *.js $out/share
      cp *.xhtml $out/share
      cp *.html $out/share
      cp *.json $out/share
      cp *.rng $out/share
      cp README.md $doc/share/${pname}
    '';
    checkPhase = ''
    '';
  };

  zlib = (pkgs.zlib.override {
    stdenv = pkgs.emscriptenStdenv;
  }).overrideAttrs
    (old: {
      nativeBuildInputs = (old.nativeBuildInputs or []) ++ [ pkg-config ];
      # we need to reset this setting!
      env = (old.env or { }) // { NIX_CFLAGS_COMPILE = ""; };
      dontStrip = true;
      outputs = [ "out" ];
      buildPhase = ''
        emmake make
      '';
      installPhase = ''
        emmake make install
      '';
      checkPhase = ''
        echo "================= testing zlib using node ================="

        echo "Compiling a custom test"
        set -x
        emcc -O2 -s EMULATE_FUNCTION_POINTER_CASTS=1 test/example.c -DZ_SOLO \
        -L. libz.a -I . -o example.js

        echo "Using node to execute the test"
        ${pkgs.nodejs}/bin/node ./example.js

        set +x
        if [ $? -ne 0 ]; then
          echo "test failed for some reason"
          exit 1;
        else
          echo "it seems to work! very good."
        fi
        echo "================= /testing zlib using node ================="
      '';

      postPatch = pkgs.lib.optionalString pkgs.stdenv.hostPlatform.isDarwin ''
        substituteInPlace configure \
          --replace '/usr/bin/libtool' 'ar' \
          --replace 'AR="libtool"' 'AR="ar"' \
          --replace 'ARFLAGS="-o"' 'ARFLAGS="-r"'
      '';
    });

}
