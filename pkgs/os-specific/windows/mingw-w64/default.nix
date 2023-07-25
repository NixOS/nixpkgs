{ lib
, stdenv
, windows
, fetchurl
, fetchpatch
, autoreconfHook
}:

let
  version = "10.0.0";
in stdenv.mkDerivation {
  pname = "mingw-w64";
  inherit version;

  src = fetchurl {
    url = "mirror://sourceforge/mingw-w64/mingw-w64-v${version}.tar.bz2";
    hash = "sha256-umtDCu1yxjo3aFMfaj/8Kw/eLFejslFFDc9ImolPCJQ=";
  };

  patches = [
    # Upstream patches to fix build parallelism
    (fetchpatch {
      name = "crt-suff-make-4.4.patch";
      url = "https://github.com/mirror/mingw-w64/commit/953bcd32ae470c4647e94de8548dda5a8f07d82d.patch";
      hash = "sha256-lrS4ZDa/Uwsj5DXajOUv+knZXan0JVU70KHHdIjJ07Y=";
    })
    (fetchpatch {
      name = "dll-dep-make-4.4.patch";
      url = "https://github.com/mirror/mingw-w64/commit/e1b0c1420bbd52ef505c71737c57393ac1397b0a.patch";
      hash = "sha256-/56Cmmy0UYTaDKIWG7CgXsThvCHK6lSbekbBOoOJSIQ=";
    })
  ];

  outputs = [ "out" "dev" ];

  configureFlags = [
    "--enable-idl"
    "--enable-secure-api"
  ];

  enableParallelBuilding = true;

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ windows.mingw_w64_headers ];
  hardeningDisable = [ "stackprotector" "fortify" ];

  meta = {
    platforms = lib.platforms.windows;
  };
}
