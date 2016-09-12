{ pkgs }:

# emscripten toolchain abstraction for nix
# https://github.com/NixOS/nixpkgs/pull/16208

with pkgs; rec {
  json_c = pkgs.json_c.override {
    stdenv = emscriptenStdenv;
  };
  
  libxml2 = (pkgs.libxml2.override {
    stdenv = emscriptenStdenv;
    supportPython = false;
  }).overrideDerivation
    (old: { 
      buildInputs = old.buildInputs ++ [ autoreconfHook pkgconfig zlib nodejs ];
      nativeBuildInputs = old.nativeBuildInputs ++ [ zlib pkgconfig ];
      # just override it with nothing so it does not fail
      autoreconfPhase = "echo autoreconfPhase not used..."; 
      checkPhase = ''
        echo "================= testing xmllint using node ================="
        emcc -O2 -s EMULATE_FUNCTION_POINTER_CASTS=1 xmllint.o \
        ./.libs/libxml2.a `pkg-config zlib --cflags` `pkg-config zlib --libs` -o ./xmllint.test.js \
        --embed-file ./test/xmlid/id_err1.xml  
        # test/xmlid/id_err2.xml:3: validity error : xml:id : attribute type should be ID
        # <!ATTLIST foo xml:id CDATA #IMPLIED>
        #                                    ^
        node ./xmllint.test.js --noout test/xmlid/id_err1.xml 2>&1  | grep 0bar   
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

    buildInputs = [ autoconf automake libtool pkgconfig gnumake libxml2 nodejs 
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
      configurePhase = ''
        # FIXME: Some tests require writing at $HOME
        HOME=$TMPDIR
        runHook preConfigure

        emconfigure ./configure --prefix=$out

        runHook postConfigure
      '';
      postPatch = stdenv.lib.optionalString stdenv.isDarwin ''
        substituteInPlace configure \
          --replace '/usr/bin/libtool' 'ar' \
          --replace 'AR="libtool"' 'AR="ar"' \
          --replace 'ARFLAGS="-o"' 'ARFLAGS="-r"'
      '';
    }); 
  
}
