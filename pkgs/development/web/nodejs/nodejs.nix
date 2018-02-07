{ stdenv, fetchurl, openssl, python2, zlib, libuv, utillinux, http-parser
, pkgconfig, which
, darwin ? null
}:

with stdenv.lib;

{ enableNpm ? true, version, sha256, patches }:

let

  inherit (darwin.apple_sdk.frameworks) CoreServices ApplicationServices;



  baseName = if enableNpm then "nodejs" else "nodejs-slim";

  sharedLibDeps = { inherit openssl zlib libuv; } // (optionalAttrs (!stdenv.isDarwin) { inherit http-parser; });

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

  stdenv.mkDerivation {
    inherit version;

    name = "${baseName}-${version}";

    src = fetchurl {
      url = "http://nodejs.org/dist/v${version}/node-v${version}.tar.xz";
      inherit sha256;
    };

    buildInputs = optionals stdenv.isDarwin [ CoreServices ApplicationServices ]
    ++ [ python2 which zlib libuv openssl ]
    ++ optionals stdenv.isLinux [ utillinux http-parser ]
    ++ optionals stdenv.isDarwin [ pkgconfig darwin.cctools ];

    configureFlags = sharedConfigureFlags ++ [ "--without-dtrace" ] ++ extraConfigFlags;

    dontDisableStatic = true;

    enableParallelBuilding = true;

    passthru.interpreterName = "nodejs";

    setupHook = ./setup-hook.sh;

    inherit patches;

    preBuild = optionalString stdenv.isDarwin ''
      sed -i -e "s|tr1/type_traits|type_traits|g" \
      -e "s|std::tr1|std|" src/util.h
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
      homepage = https://nodejs.org;
      license = licenses.mit;
      maintainers = with maintainers; [ goibhniu havvy gilligan cko ];
      platforms = platforms.linux ++ platforms.darwin;
    };

    passthru.python = python2; # to ensure nodeEnv uses the same version
}
