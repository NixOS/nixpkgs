{ stdenv, fetchurl, fetchpatch
# native deps.
, runCommand, pkgconfig, meson, ninja, makeWrapper
# build+runtime deps.
, knot-dns, luajitPackages, libuv, gnutls, lmdb
, systemd, libcap_ng, dns-root-data, nghttp2 # optionals, in principle
# test-only deps.
, cmocka, which, cacert
, extraFeatures ? false /* catch-all if defaults aren't enough */
}:
let # un-indented, over the whole file

result = if extraFeatures then wrapped-full else unwrapped;

inherit (stdenv.lib) optional optionals optionalString;
lua = luajitPackages;

unwrapped = stdenv.mkDerivation rec {
  pname = "knot-resolver";
  version = "5.2.1";

  src = fetchurl {
    url = "https://secure.nic.cz/files/knot-resolver/${pname}-${version}.tar.xz";
    sha256 = "aa37b744c400f437acba7a54aebcbdbe722ece743d342cbc39f2dd8087f05826";
  };

  outputs = [ "out" "dev" ];

  # Path fixups for the NixOS service.
  postPatch = ''
    patch meson.build <<EOF
    @@ -50,2 +50,2 @@
    -systemd_work_dir = prefix / get_option('localstatedir') / 'lib' / 'knot-resolver'
    -systemd_cache_dir = prefix / get_option('localstatedir') / 'cache' / 'knot-resolver'
    +systemd_work_dir  = '/var/lib/knot-resolver'
    +systemd_cache_dir = '/var/cache/knot-resolver'
    EOF

    # ExecStart can't be overwritten in overrides.
    # We need that to use wrapped executable and correct config file.
    sed '/^ExecStart=/d' -i systemd/kresd@.service.in
  ''
    # some tests have issues with network sandboxing, apparently
  + optionalString doInstallCheck ''
    echo 'os.exit(77)' > daemon/lua/trust_anchors.test/bootstrap.test.lua
    sed '/^[[:blank:]]*test_dstaddr,$/d' -i tests/config/doh2.test.lua
  '';

  preConfigure = ''
    patchShebangs scripts/
  '';

  nativeBuildInputs = [ pkgconfig meson ninja ];

  # http://knot-resolver.readthedocs.io/en/latest/build.html#requirements
  buildInputs = [ knot-dns lua.lua libuv gnutls lmdb ]
    ++ optionals stdenv.isLinux [ systemd libcap_ng ]
    ++ [ nghttp2 ]
    ## optional dependencies; TODO: dnstap
    ;

  mesonFlags = [
    "-Dkeyfile_default=${dns-root-data}/root.ds"
    "-Droot_hints=${dns-root-data}/root.hints"
    "-Dinstall_kresd_conf=disabled" # not really useful; examples are inside share/doc/
    "--default-library=static" # not used by anyone
  ]
  ++ optional doInstallCheck "-Dunit_tests=enabled"
  ++ optional (doInstallCheck && !stdenv.isDarwin) "-Dconfig_tests=enabled"
  ++ optional stdenv.isLinux "-Dsystemd_files=enabled" # used by NixOS service
    #"-Dextra_tests=enabled" # not suitable as in-distro tests; many deps, too.
  ;

  postInstall = ''
    rm "$out"/lib/libkres.a
    rm "$out"/lib/knot-resolver/upgrade-4-to-5.lua # not meaningful on NixOS
  '' + optionalString stdenv.targetPlatform.isLinux ''
    rm -r "$out"/lib/sysusers.d/ # ATM more likely to harm than help
  '';

  doInstallCheck = with stdenv; hostPlatform == buildPlatform;
  installCheckInputs = [ cmocka which cacert lua.cqueues lua.basexx lua.http ];
  installCheckPhase = ''
    meson test --print-errorlogs
  '';

  meta = with stdenv.lib; {
    description = "Caching validating DNS resolver, from .cz domain registry";
    homepage = "https://knot-resolver.cz";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = [ maintainers.vcunat /* upstream developer */ ];
  };
};

wrapped-full = runCommand unwrapped.name
  {
    nativeBuildInputs = [ makeWrapper ];
    buildInputs = with luajitPackages; [
      # For http module, prefill module, trust anchor bootstrap.
      # It brings lots of deps; some are useful elsewhere (e.g. cqueues).
      http
      # psl isn't in nixpkgs yet, but policy.slice_randomize_psl() seems not important.
    ];
    preferLocalBuild = true;
    allowSubstitutes = false;
  }
  ''
    mkdir -p "$out"/bin
    makeWrapper '${unwrapped}/bin/kresd' "$out"/bin/kresd \
      --set LUA_PATH  "$LUA_PATH" \
      --set LUA_CPATH "$LUA_CPATH"

    ln -sr '${unwrapped}/share' "$out"/
    ln -sr '${unwrapped}/lib'   "$out"/ # useful in NixOS service
    ln -sr "$out"/{bin,sbin}

    echo "Checking that 'http' module loads, i.e. lua search paths work:"
    echo "modules.load('http')" > test-http.lua
    echo -e 'quit()' | env -i "$out"/bin/kresd -a 127.0.0.1#53535 -c test-http.lua
  '';

in result
