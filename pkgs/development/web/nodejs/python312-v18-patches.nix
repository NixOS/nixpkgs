{ fetchpatch2, buildPackages }:
[
  (fetchpatch2 {
    # Fix build with Python 3.12.
    # https://github.com/nodejs/node/pull/50582
    url = "https://github.com/nodejs/node/commit/95534ad82f4e33f53fd50efe633d43f8da70cba6.patch";
    hash = "sha256-7WRYed2dzOhKhHxsIO7Qv/D1VMJkfUlsyhVVMOBfpTM=";
  })
  (fetchpatch2 {
    # Fix GYP compatibility with Python 3.12.
    # https://github.com/nodejs/gyp-next/pull/201
    url = "https://github.com/nodejs/gyp-next/commit/874233e19748f584f73461d636d4ae9f86a88c7b.patch";
    hash = "sha256-kNDTXEsBJ3KvXnW0Pns5znoxECOSzACAxXYr60j+C0U=";
    stripLen = 1;
    extraPrefix = "tools/gyp/";
    includes = [ "tools/gyp/pylib/gyp/input.py" ];
  })
  (fetchpatch2 {
    # Vendor packaging in GYP for Python 3.12.
    # https://github.com/nodejs/gyp-next/pull/214
    url = "https://github.com/nodejs/gyp-next/commit/004c0b0342fd470c9249d1a0f84f7032cd5c8241.patch";
    hash = "sha256-9Pc2Y3staNq3Cz2b6KTNl9W1RJtBKfG+jjpD0yoRJco=";
    includes = [ "pylib/*" ];
    # fetchpatch gets confused by new files and adds extraPrefix to /dev/null
    # placeholder for the old paths. As a workaround, manually set prefix only
    # for the new paths. Also note that currently fetchpatch is not using
    # nativeBuildInputs. See also https://github.com/NixOS/nixpkgs/pull/323824
    postFetch = ''
      ${buildPackages.patchutils_0_4_2}/bin/filterdiff --strip=1 --addnewprefix=b/tools/gyp/ -- "$out" >"$tmpfile"
      mv -- "$tmpfile" "$out"
    '';
  })
]
