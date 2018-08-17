{ stdenv, fetchurl, openssl, python2, zlib, libuv, utillinux, http-parser
, pkgconfig, which
# Updater dependencies
, writeScript, coreutils, gnugrep, jq, curl, common-updater-scripts, nix
, gnupg
, darwin, xcbuild
, procps
}:

with stdenv.lib;

{ enableNpm ? true, version, sha256, patches ? [] } @args:

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

  copyLibHeaders =
    map
      (name: "${getDev sharedLibDeps.${name}}/include/*")
      (builtins.attrNames sharedLibDeps);

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
      ++ [ python2 zlib libuv openssl http-parser ];

    nativeBuildInputs = [ which utillinux ]
      ++ optionals stdenv.isDarwin [ pkgconfig xcbuild ];

    configureFlags = sharedConfigureFlags ++ [ "--without-dtrace" ] ++ extraConfigFlags;

    dontDisableStatic = true;

    enableParallelBuilding = true;

    passthru.interpreterName = "nodejs";

    setupHook = ./setup-hook.sh;

    pos = builtins.unsafeGetAttrPos "version" args;

    inherit patches;

    postPatch = ''
      patchShebangs .
      sed -i 's/raise.*No Xcode or CLT version detected.*/version = "7.0.0"/' tools/gyp/pylib/gyp/xcode_emulation.py

      # fix tests
      for a in test/parallel/test-child-process-env.js \
               test/parallel/test-child-process-exec-env.js \
               test/parallel/test-child-process-default-options.js \
               test/fixtures/syntax/good_syntax_shebang.js \
               test/fixtures/syntax/bad_syntax_shebang.js ; do
        substituteInPlace $a \
          --replace "/usr/bin/env" "${coreutils}/bin/env"
      done
    '' + optionalString stdenv.isDarwin ''
      sed -i -e "s|tr1/type_traits|type_traits|g" \
             -e "s|std::tr1|std|" src/util.h
    '';

    checkInputs = [ procps ];
    doCheck = false; # fails 4 out of 1453 tests

    postInstall = ''
      paxmark m $out/bin/node
      PATH=$out/bin:$PATH patchShebangs $out

      ${optionalString enableNpm ''
        mkdir -p $out/share/bash-completion/completions/
        $out/bin/npm completion > $out/share/bash-completion/completions/npm
      ''}

      # install the missing headers for node-gyp
      cp -r ${concatStringsSep " " copyLibHeaders} $out/include/node
    '';

    passthru.updateScript = import ./update.nix {
      inherit writeScript coreutils gnugrep jq curl common-updater-scripts gnupg nix;
      inherit (stdenv) lib;
      majorVersion = with stdenv.lib; elemAt (splitString "." version) 0;
    };

    meta = {
      description = "Event-driven I/O framework for the V8 JavaScript engine";
      homepage = https://nodejs.org;
      license = licenses.mit;
      maintainers = with maintainers; [ goibhniu gilligan cko ];
      platforms = platforms.linux ++ platforms.darwin;
    };

    passthru.python = python2; # to ensure nodeEnv uses the same version
}
