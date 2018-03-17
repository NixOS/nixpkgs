{ pkgs }:

with pkgs;

# emscripten toolchain abstraction for nix
# https://github.com/NixOS/nixpkgs/pull/16208

rec {
  json_c = (pkgs.json_c.override {
    stdenv = pkgs.emscriptenStdenv;
  }).overrideDerivation
    (old: {
      nativeBuildInputs = [ autoreconfHook pkgconfig zlib ];
      buildInputs = old.buildInputs ++ [ nodejs automake autoconf python ];
      configurePhase = ''
        HOME=$TMPDIR
        emconfigure ./configure --prefix=$out 
      '';
    });
  
  libxml2 = (pkgs.libxml2.override {
    stdenv = pkgs.emscriptenStdenv;
    pythonSupport = false;
  }).overrideDerivation
    (old: { 
      propagatedBuildInputs = [ zlib ];
      buildInputs = old.buildInputs ++ [ pkgs.python pkgs.pkgconfig ];

      # just override it with nothing so it does not fail
      autoreconfPhase = "echo autoreconfPhase not used..."; 
      configurePhase = ''
        HOME=$TMPDIR
        emconfigure ./configure --prefix=$out --without-python
      '';
      checkPhase = ''
        echo "================= testing xmllint using node ================="

        echo "Compiling a custom test"
        set -x
        emcc -O2 -s EMULATE_FUNCTION_POINTER_CASTS=1 xmllint.o \
        ./.libs/libxml2.a `pkg-config zlib --cflags` `pkg-config zlib --libs` -o ./xmllint.test.js \
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
        echo "================= /testing xmllint using node ================="
      '';
    });            
  
  xmlmirror = pkgs.buildEmscriptenPackage rec {
    name = "xmlmirror";

    nativeBuildInputs = [ pkgconfig pkgs.emscriptenPackages.zlib ];
    buildInputs = [ autoconf automake libtool gnumake libxml2 nodejs python openjdk json_c zlib ];

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
    '';
    
    buildPhase = ''
      HOME=$TMPDIR
      make -f Makefile.emEnv
    '';
    
    outputs = [ "out" "doc" ];
    
    installPhase = ''
      mkdir -p $out/share
      mkdir -p $doc/share/${name}
      
      cp Demo* $out/share
      cp -R codemirror-5.12 $out/share
      cp fastXmlLint.js* $out/share
      cp *.xsd $out/share
      cp *.js $out/share
      cp *.xhtml $out/share
      cp *.html $out/share
      cp *.json $out/share
      cp *.rng $out/share
      cp README.md $doc/share/${name}
    '';
    
    postInstall = ''
    '';
  };  

  zlib = (pkgs.zlib.override {
    stdenv = pkgs.emscriptenStdenv;
  }).overrideDerivation
    (old: { 
      buildInputs = old.buildInputs ++ [ python pkgconfig ];
      NIX_CFLAGS_COMPILE="";
      configurePhase = ''
        # FIXME: Some tests require writing at $HOME
        HOME=$TMPDIR
        runHook preConfigure

        #export EMCC_DEBUG=2
        emconfigure ./configure --prefix=$out --shared

        runHook postConfigure
      '';
      dontStrip = true;
      outputs = [ "out" ];
      buildPhase = ''
        emmake make
      '';
      installPhase = ''
        emmake make install
      '';
      postPatch = pkgs.stdenv.lib.optionalString pkgs.stdenv.isDarwin ''
        substituteInPlace configure \
          --replace '/usr/bin/libtool' 'ar' \
          --replace 'AR="libtool"' 'AR="ar"' \
          --replace 'ARFLAGS="-o"' 'ARFLAGS="-r"'
      '';
    }); 
  
}
