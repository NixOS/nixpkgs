{ stdenv, fetchurl, openssl, python, zlib, libuv, v8, utillinux, http-parser, libtool,
darwin, pkgconfig, runCommand, which, unstableVersion ? false
}:

let
  version = if unstableVersion then "0.11.13" else "0.12.0";

  deps = {
    inherit openssl zlib libuv;

    # disabled system v8 because v8 3.14 no longer receives security fixes
    # we fall back to nodejs' internal v8 copy which receives backports for now
    # inherit v8
  } // (stdenv.lib.optionalAttrs (!stdenv.isDarwin) {
    inherit http-parser;
  });

  sharedConfigureFlags = name: [
    "--shared-${name}"
    "--shared-${name}-includes=${builtins.getAttr name deps}/include"
    "--shared-${name}-libpath=${builtins.getAttr name deps}/lib"
  ] ++ stdenv.lib.optional stdenv.isDarwin "--without-dtrace";

  inherit (stdenv.lib) concatMap optional optionals maintainers licenses platforms;
in stdenv.mkDerivation {
  name = "nodejs-${version}";

  src = fetchurl {
    url = "http://nodejs.org/dist/v${version}/node-v${version}.tar.gz";
    sha256 = if unstableVersion
             then "1642zj3sajhqflfhb8fsvy84w9mm85wagm8w8300gydd2q6fkmhm"
             else "0cifd2qhpyrbxx71a4hsagzk24qas8m5zvwcyhx69cz9yhxf404p";
  };

  configureFlags = concatMap sharedConfigureFlags (builtins.attrNames deps);

  prePatch = ''
    patchShebangs .
  '';

  patches = if stdenv.isDarwin then [ ./no-xcode.patch ] else null;

  postPatch = if stdenv.isDarwin then ''
    (cd tools/gyp; patch -Np1 -i ${../../python-modules/gyp/no-darwin-cflags.patch})
  '' else null;

  buildInputs = [ python which libtool ]
    ++ (optional stdenv.isLinux utillinux)
    ++ optionals stdenv.isDarwin [ pkgconfig openssl ];
  setupHook = ./setup-hook.sh;

  enableParallelBuilding = true;

  passthru.interpreterName = "nodejs";

  meta = {
    description = "Event-driven I/O framework for the V8 JavaScript engine";
    homepage = http://nodejs.org;
    license = licenses.mit;
    maintainers = [ maintainers.goibhniu maintainers.shlevy ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
