{ stdenv, fetchurl, fetchpatch, runCommand, pkgconfig, hexdump, which
, knot-dns, luajit, libuv, lmdb, gnutls, nettle
, cmocka, systemd, dns-root-data, makeWrapper
, extraFeatures ? false /* catch-all if defaults aren't enough */
, luajitPackages
}:
let # un-indented, over the whole file

result = if extraFeatures then wrapped-full else unwrapped;

inherit (stdenv.lib) optional;

unwrapped = stdenv.mkDerivation rec {
  name = "knot-resolver-${version}";
  version = "3.2.1";

  src = fetchurl {
    url = "https://secure.nic.cz/files/knot-resolver/${name}.tar.xz";
    sha256 = "d1396888ec3a63f19dccdf2b7dbcb0d16a5d8642766824b47f4c21be90ce362b";
  };

  patches = [
    (fetchpatch {
      name = "support-libzscanner-2.8.diff";
      url = "https://gitlab.labs.nic.cz/knot/knot-resolver/commit/186f263.diff";
      sha256 = "19zqigvc7m2a4j6bk9whx7gj0v009568rz5qwk052z7pzfikr8mk";
    })
  ];

  # Short-lived cross fix, as upstream is migrating to meson anyway.
  postPatch = ''
    substituteInPlace platform.mk --replace "objdump" "$OBJDUMP"
  '';

  outputs = [ "out" "dev" ];

  configurePhase = "patchShebangs scripts/";

  nativeBuildInputs = [ pkgconfig which hexdump ];

  # http://knot-resolver.readthedocs.io/en/latest/build.html#requirements
  buildInputs = [ knot-dns luajit libuv gnutls nettle lmdb ]
    ++ optional stdenv.isLinux systemd # sd_notify
    ## optional dependencies; TODO: libedit, dnstap
    ;

  checkInputs = [ cmocka ];

  makeFlags = [
    "PREFIX=$(out)"
    "ROOTHINTS=${dns-root-data}/root.hints"
    "KEYFILE_DEFAULT=${dns-root-data}/root.ds"
  ];
  CFLAGS = [ "-O2" "-DNDEBUG" ];

  enableParallelBuilding = true;

  doCheck = true;
  doInstallCheck = false; # FIXME
  preInstallCheck = ''
    patchShebangs tests/config/runtest.sh
  '';

  postInstall = ''
    rm "$out"/etc/knot-resolver/root.hints # using system-wide instead
  '';

  meta = with stdenv.lib; {
    description = "Caching validating DNS resolver, from .cz domain registry";
    homepage = https://knot-resolver.cz;
    license = licenses.gpl3Plus;
    # Platforms using negative pointers for stack won't work ATM due to LuaJIT impl.
    platforms = filter (p: p != "aarch64-linux") platforms.unix;
    maintainers = [ maintainers.vcunat /* upstream developer */ ];
  };
};

# FIXME: revert this back after resolving
# https://github.com/NixOS/nixpkgs/pull/63108#issuecomment-508670438
wrapped-full =
  with stdenv.lib;
  with luajitPackages;
  let
    luaPkgs = [
      luasec luasocket # trust anchor bootstrap, prefill module
      luafilesystem # prefill module
      http # for http module; brings lots of deps; some are useful elsewhere
      cqueues fifo lpeg lpeg_patterns luaossl compat53 basexx binaryheap
    ];
  in runCommand unwrapped.name
  {
    nativeBuildInputs = [ makeWrapper ];
    preferLocalBuild = true;
    allowSubstitutes = false;
  }
  ''
    mkdir -p "$out"/{bin,share}
    makeWrapper '${unwrapped}/bin/kresd' "$out"/bin/kresd \
      --set LUA_PATH  '${concatStringsSep ";" (map getLuaPath  luaPkgs)}' \
      --set LUA_CPATH '${concatStringsSep ";" (map getLuaCPath luaPkgs)}'

    ln -sr '${unwrapped}/share/man' "$out"/share/
    ln -sr "$out"/{bin,sbin}

    echo "Checking that 'http' module loads, i.e. lua search paths work:"
    echo "modules.load('http')" > test-http.lua
    echo -e 'quit()' | env -i "$out"/bin/kresd -a 127.0.0.1#53535 -c test-http.lua
  '';

in result
