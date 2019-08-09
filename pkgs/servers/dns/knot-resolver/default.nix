{ stdenv, fetchurl
# native deps.
, runCommand, pkgconfig, meson, ninja, makeWrapper
# build+runtime deps.
, knot-dns, luajitPackages, libuv, gnutls, lmdb, systemd, dns-root-data
# test-only deps.
, cmocka, which, cacert
, extraFeatures ? false /* catch-all if defaults aren't enough */
}:
let # un-indented, over the whole file

result = if extraFeatures then wrapped-full else unwrapped;

inherit (stdenv.lib) optional optionals concatStringsSep;
lua = luajitPackages;

# FIXME: remove these usages once resolving
# https://github.com/NixOS/nixpkgs/pull/63108#issuecomment-508670438
exportLuaPathsFor = luaPkgs: ''
  export LUA_PATH='${ concatStringsSep ";" (map lua.getLuaPath  luaPkgs)}'
  export LUA_CPATH='${concatStringsSep ";" (map lua.getLuaCPath luaPkgs)}'
'';

unwrapped = stdenv.mkDerivation rec {
  name = "knot-resolver-${version}";
  version = "4.1.0";

  src = fetchurl {
    url = "https://secure.nic.cz/files/knot-resolver/${name}.tar.xz";
    sha256 = "2fe470f9bb1007667cdd448f758087244b7195a0234c2b100a9beeed0a2d3e68";
  };

  # https://gitlab.labs.nic.cz/knot/knot-resolver/issues/496
  postPatch = "sed '/prefill.test.lua/d' -i modules/meson.build";

  outputs = [ "out" "dev" ];

  preConfigure = ''
    patchShebangs scripts/
  ''
    + stdenv.lib.optionalString doInstallCheck (exportLuaPathsFor [ lua.cqueues lua.basexx ]);

  nativeBuildInputs = [ pkgconfig meson ninja ];

  # http://knot-resolver.readthedocs.io/en/latest/build.html#requirements
  buildInputs = [ knot-dns lua.lua libuv gnutls lmdb ]
    ++ optional stdenv.isLinux systemd # passing sockets, sd_notify
    ## optional dependencies; TODO: libedit, dnstap
    ;

  mesonFlags = [
    "-Dkeyfile_default=${dns-root-data}/root.ds"
    "-Droot_hints=${dns-root-data}/root.hints"
    "-Dinstall_kresd_conf=disabled" # not really useful; examples are inside share/doc/
    "--default-library=static" # not used by anyone
  ]
  # kres-cache-gc won't work on Darwin before 10.12 due to missing clock_gettime()
  ++ optional stdenv.hostPlatform.isDarwin "-Dutils=disabled"
  ++ optionals doInstallCheck [
    "-Dunit_tests=enabled"
    #"-Dconfig_tests=enabled" #FIXME: check-no-ca-store.diff - as gnutls isn't patched
    #"-Dextra_tests=enabled" # not suitable as in-distro tests; many deps, too.
  ];

  postInstall = ''
    rm "$out"/lib/libkres.a
  '';

  # aarch64: see https://github.com/wahern/cqueues/issues/223
  doInstallCheck = with stdenv; hostPlatform == buildPlatform && !hostPlatform.isAarch64;
  installCheckInputs = [ cmocka which ];
  installCheckPhase = ''
    meson test --print-errorlogs
  '';

  meta = with stdenv.lib; {
    description = "Caching validating DNS resolver, from .cz domain registry";
    homepage = https://knot-resolver.cz;
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = [ maintainers.vcunat /* upstream developer */ ];
  };
};

wrapped-full = with luajitPackages; let
    luaPkgs =  [
      luasec luasocket # trust anchor bootstrap, prefill module
      lfs # prefill module
      # Almost all is for the 'http' module:
      http cqueues fifo lpeg lpeg_patterns luaossl compat53 basexx
    ];
  in runCommand unwrapped.name
  {
    nativeBuildInputs = [ makeWrapper ];
    preferLocalBuild = true;
    allowSubstitutes = false;
  }
  (exportLuaPathsFor luaPkgs
  + ''
    mkdir -p "$out/sbin" "$out/share"
    makeWrapper '${unwrapped}/sbin/kresd' "$out"/sbin/kresd \
      --set LUA_PATH  "$LUA_PATH" \
      --set LUA_CPATH "$LUA_CPATH"
    ln -sr '${unwrapped}/share/man' "$out"/share/
    ln -sr "$out"/{sbin,bin}

    echo "Checking that 'http' module loads, i.e. lua search paths work:"
    echo "modules.load('http')" > test-http.lua
    echo -e 'quit()' | env -i "$out"/bin/kresd -a 127.0.0.1#53535 -c test-http.lua
  '');

in result
