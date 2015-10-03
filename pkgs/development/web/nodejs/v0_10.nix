{ stdenv, fetchurl, openssl, python, zlib, v8, utillinux, http-parser, c-ares
, pkgconfig, runCommand, which, libtool

# apple frameworks
, CoreServices, ApplicationServices, Carbon, Foundation
}:

let
  version = "0.10.38";

  # !!! Should we also do shared libuv?
  deps = {
    inherit openssl zlib;

    # disabled system v8 because v8 3.14 no longer receives security fixes
    # we fall back to nodejs' internal v8 copy which receives backports for now
    # inherit v8
  } // (stdenv.lib.optionalAttrs (!stdenv.isDarwin) {
    inherit http-parser;
  })
  // ({ cares = c-ares; });

  sharedConfigureFlags = name: [
    "--shared-${name}"
    "--shared-${name}-includes=${builtins.getAttr name deps}/include"
    "--shared-${name}-libpath=${builtins.getAttr name deps}/lib"
  ];

  inherit (stdenv.lib) concatMap optional optionals maintainers licenses platforms;
in stdenv.mkDerivation {
  name = "nodejs-${version}";

  src = fetchurl {
    url = "http://nodejs.org/dist/v${version}/node-v${version}.tar.gz";
    sha256 = "12xpa9jzry5g0j41908498qqs8v0q6miqkv6mggyzas8bvnshgai";
  };

  configureFlags = concatMap sharedConfigureFlags (builtins.attrNames deps) ++
    stdenv.lib.optional stdenv.isDarwin "--without-dtrace";

  prePatch = ''
    patchShebangs .
  '';

  patches = stdenv.lib.optional stdenv.isDarwin ./no-xcode.patch;

  postPatch = stdenv.lib.optionalString stdenv.isDarwin ''
    (cd tools/gyp; patch -Np1 -i ${../../python-modules/gyp/no-darwin-cflags.patch})
  '';

  buildInputs = [ python which ]
    ++ (optional stdenv.isLinux utillinux)
    ++ optionals stdenv.isDarwin [ pkgconfig openssl libtool CoreServices ApplicationServices Foundation ];
  propagatedBuildInputs = optionals stdenv.isDarwin [ Carbon ];
  setupHook = ./setup-hook.sh;

  enableParallelBuilding = true;

  passthru.interpreterName = "nodejs-0.10";

  meta = {
    description = "Event-driven I/O framework for the V8 JavaScript engine";
    homepage = http://nodejs.org;
    license = licenses.mit;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
