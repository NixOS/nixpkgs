{ stdenv, fetchurl, openssl, python2, zlib, libuv, v8, utillinux, http-parser
, pkgconfig, runCommand, which, libtool, fetchpatch
, callPackage
, darwin ? null
, enableNpm ? true
}:

with stdenv.lib;

let
  inherit (darwin.apple_sdk.frameworks) CoreServices ApplicationServices;

  sharedLibDeps = { inherit openssl zlib libuv; } // (optionalAttrs (!stdenv.isDarwin) { inherit 
http-parser; });

  sharedConfigureFlags = concatMap (name: [
    "--shared-${name}"
    "--shared-${name}-libpath=${getLib sharedLibDeps.${name}}/lib"
    /** Closure notes: we explicitly avoid specifying --shared-*-includes,
     *  as that would put the paths into bin/nodejs.
     *  Including pkgconfig in build inputs would also have the same effect!
     */
  ]) (builtins.attrNames sharedLibDeps);

  extraConfigFlags = optionals (!enableNpm) [ "--without-npm" ];
in

  rec {

    buildInputs = optionals stdenv.isDarwin [ CoreServices ApplicationServices ]
    ++ [ python2 which zlib libuv openssl v8 ]
    ++ optionals stdenv.isLinux [ utillinux http-parser ]
    ++ optionals stdenv.isDarwin [ pkgconfig libtool ];

    configureFlags = sharedConfigureFlags ++ [  "--without-dtrace" "--without-bundled-v8" 
"--without-inspector" ]
 ++ extraConfigFlags;

    dontDisableStatic = true;

    enableParallelBuilding = true;

    passthru.interpreterName = "nodejs";
    

    setupHook = ./setup-hook.sh;

    patches = optionals stdenv.isDarwin [ ./no-xcode.patch ];

    preBuild ='' sed -i -e "s|deps/v8/build/toolchain\.gypi deps/v8/build/features\.gypi deps/v8/tools/gyp/v8.gyp||" Makefile'' +
optionalString stdenv.isDarwin ''
      sed -i -e "s|tr1/type_traits|type_traits|g" \
      -e "s|std::tr1|std|" src/util.h
    '';
    preConfigure = ''
       sed -i -e "s|<(PRODUCT_DIR)/libv8_base\.a|${v8}/lib/libv8_base\.a|" \
        -e "s|<(PRODUCT_DIR)/obj\.target/deps/v8/src/libv8_base\.a|${v8}/lib/libv8_base\.a|" common.gypi
       sed -i -e "s|<(V8_BASE)|${v8}/lib/libv8_base\.a|" node.gyp
       export C_INCLUDE_PATH="$C_INCLUDE_PATH:${v8}/include"
       export CPLUS_INCLUDE_PATH="$CPLUS_INCLUDE_PATH:${v8}/include"
    '';


    prePatch = ''
      patchShebangs .
      sed -i 's/raise.*No Xcode or CLT version detected.*/version = "7.0.0"/' tools/gyp/pylib/gyp/xcode_emulation.py
    '';

    postInstall = ''
      paxmark m $out/bin/node
      PATH=$out/bin:$PATH patchShebangs $out

      ${optionalString enableNpm '' 
        mkdir -p $out/share/bash-completion/completions/
        $out/bin/npm completion > $out/share/bash-completion/completions/npm
      ''}
    '';

    meta = {
      description = "Event-driven I/O framework for the V8 JavaScript engine";
      homepage = http://nodejs.org;
      license = licenses.mit;
      maintainers = with maintainers; [ goibhniu havvy gilligan cko ];
      platforms = platforms.linux ++ platforms.darwin;
    };

    passthru.python = python2; # to ensure nodeEnv uses the same version
}
