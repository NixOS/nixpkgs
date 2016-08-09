{ stdenv, fetchurl, openssl, python, zlib, libuv, v8, utillinux, http-parser
, pkgconfig, runCommand, which, libtool
, version
, sha256 ? null
, src ? fetchurl { url = "https://nodejs.org/download/release/v${version}/node-v${version}.tar.xz"; inherit sha256; }
, preBuild ? ""
, extraConfigFlags ? []
, extraBuildInputs ? []
, ...
}:

assert stdenv.system != "armv5tel-linux";

let

  deps = {
    inherit openssl zlib libuv;
  } // (stdenv.lib.optionalAttrs (!stdenv.isDarwin) {
    inherit http-parser;
  });

  sharedConfigureFlags = name: [
    "--shared-${name}"
    "--shared-${name}-includes=${builtins.getAttr name deps}/include"
    "--shared-${name}-libpath=${builtins.getAttr name deps}/lib"
  ];

  inherit (stdenv.lib) concatMap optional optionals maintainers licenses platforms;

in stdenv.mkDerivation {

  inherit version src preBuild;

  name = "nodejs-${version}";

  configureFlags = concatMap sharedConfigureFlags (builtins.attrNames deps) ++ [ "--without-dtrace" ] ++ extraConfigFlags;
  dontDisableStatic = true;
  prePatch = ''
    patchShebangs .
    sed -i 's/raise.*No Xcode or CLT version detected.*/version = "7.0.0"/' tools/gyp/pylib/gyp/xcode_emulation.py
  '';

  postInstall = ''
    PATH=$out/bin:$PATH patchShebangs $out
  '';

  patches = stdenv.lib.optionals stdenv.isDarwin [ ./no-xcode.patch ];

  buildInputs = extraBuildInputs
    ++ [ python which zlib libuv openssl ]
    ++ optionals stdenv.isLinux [ utillinux http-parser ]
    ++ optionals stdenv.isDarwin [ pkgconfig libtool ];
  setupHook = ./setup-hook.sh;

  enableParallelBuilding = true;

  passthru.interpreterName = "nodejs";

  meta = {
    description = "Event-driven I/O framework for the V8 JavaScript engine";
    homepage = http://nodejs.org;
    license = licenses.mit;
    maintainers = [ maintainers.goibhniu maintainers.havvy maintainers.gilligan maintainers.cko ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
