{ pkgs }:

# emscripten toolchain abstraction for nix
# https://github.com/NixOS/nixpkgs/pull/16208

with pkgs; rec {
  json_c = (pkgs.json_c.override {
    stdenv = emscriptenStdenv;
  }).overrideDerivation
    (old: {
      nativeBuildInputs = old.nativeBuildInputs ++ [ autoreconfHook pkgconfig ];
      buildInputs = old.buildInputs ++ [ zlib nodejs automake autoconf python ];
      configurePhase = ''
        HOME=$TMPDIR
        emconfigure ./configure --prefix=$out 
      '';
    });
  
  
  libxml2 = (pkgs.libxml2.override {
    stdenv = emscriptenStdenv;
    pythonSupport = false;
  }).overrideDerivation
    (old: { 
      nativeBuildInputs = old.nativeBuildInputs ++ [ autoreconfHook pkgconfig ];
      buildInputs = old.buildInputs ++ [ zlib nodejs python ];
      # just override it with nothing so it does not fail
      autoreconfPhase = "echo autoreconfPhase not used..."; 

      configurePhase = ''
        HOME=$TMPDIR
        emconfigure ./configure --prefix=$out --without-python
      '';
      checkPhase = ''
        echo "================= testing xmllint using node ================="
        echo "~~~ ${zlib.static} ~~~"
        echo "1xx)"
        echo "pkgs-config zlib --cflags: `pkg-config zlib --cflags`"
        echo "1xx-)"
        echo "pkgs-config zlib --libs: `pkg-config zlib --libs`"
        echo "1xx--)"
        emcc -O2 -s EMULATE_FUNCTION_POINTER_CASTS=1 xmllint.o \
        ./.libs/libxml2.a `pkg-config zlib --cflags` `pkg-config zlib --libs` -o ./xmllint.test.js \
        --embed-file ./test/xmlid/id_err1.xml  
        
        # code below works but https://github.com/kripken/emscripten/wiki/Linking#overview-of-dynamic-linking would be so much better to have!
        #emcc -O2 -s EMULATE_FUNCTION_POINTER_CASTS=1 xmllint.o \
        #./.libs/libxml2.a `pkg-config zlib --cflags` ${zlibs.static}/lib/libz.a -o ./xmllint.test.js \
        #--embed-file ./test/xmlid/id_err1.xml  

        # code below fails
        #emcc -O2 -s EMULATE_FUNCTION_POINTER_CASTS=1 xmllint.o \
        #./.libs/libxml2.a `pkg-config zlib --cflags` `pkg-config zlib --libs` -o ./xmllint.test.js \
        #--embed-file ./test/xmlid/id_err1.xml  


        echo "2xx)"
        # test/xmlid/id_err2.xml:3: validity error : xml:id : attribute type should be ID
        # <!ATTLIST foo xml:id CDATA #IMPLIED>
        #                                    ^
        node ./xmllint.test.js --noout test/xmlid/id_err1.xml
        echo "3xx)"
        node ./xmllint.test.js --noout test/xmlid/id_err1.xml 2>&1  | grep 0bar   
        echo "4xx)"
        if [ $? -ne 0 ]; then
          echo "xmllint unit test failed, please fix this package"
          exit 1;
        else
          echo "since there is no stupid text containing 'foo xml:id' it seems to work! very good."
        fi
        echo "================= /testing xmllint using node ================="
      '';
    });            
  
  xmlmirror = buildEmscriptenPackage rec {
    name = "xmlmirror";

    nativeBuildInputs = [ pkgconfig ];
    buildInputs = [ autoconf automake libtool gnumake libxml2 nodejs 
       python openjdk json_c zlib ];

    src = fetchgit {
      url = "https://gitlab.com/odfplugfest/xmlmirror.git";
      rev = "4fd7e86f7c9526b8f4c1733e5c8b45175860a8fd";
      sha256 = "1jasdqnbdnb83wbcnyrp32f36w3xwhwp0wq8lwwmhqagxrij1r4b";
    };
     
    configurePhase = ''
      rm -f fastXmlLint.js*
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
    stdenv = emscriptenStdenv;
  }).overrideDerivation
    (old: { 
      buildInputs = old.buildInputs ++ [ python ];
      configurePhase = ''
        # FIXME: Some tests require writing at $HOME
        HOME=$TMPDIR
        runHook preConfigure

        export EMCC_DEBUG=2

        emconfigure ./configure --prefix=$out
        cat configure.log

        runHook postConfigure
      '';
      #buildPhase = ''
      #  echo "flux2"
      #  emmake make
      #'';
      postPatch = stdenv.lib.optionalString stdenv.isDarwin ''
        substituteInPlace configure \
          --replace '/usr/bin/libtool' 'ar' \
          --replace 'AR="libtool"' 'AR="ar"' \
          --replace 'ARFLAGS="-o"' 'ARFLAGS="-r"'
      '';
    }); 
  
}
