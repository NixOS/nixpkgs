{ lib
, stdenv
, getdns
, htslib
, libsass
, openssl
, pkg-config
, raylib
, SDL2
, tkrzw
, xorg
}:

# The following is list of overrides that take three arguments each:
# - lockAttrs: - an attrset from a Nim lockfile, use this for making constraints on the locked library
# - finalAttrs: - final arguments to the depender package
# - prevAttrs: - preceding arguments to the depender package
{
  jester = lockAttrs: finalAttrs:
    { buildInputs ? [ ], ... }: {
      buildInputs = buildInputs ++ [ openssl ];
    };

  hts = lockAttrs: finalAttrs:
    { buildInputs ? [ ], ... }: {
      buildInputs = buildInputs ++ [ htslib ];
    };

  getdns = lockAttrs: finalAttrs:
    { nativeBuildInputs ? [ ], buildInputs ? [ ], ... }: {
      nativeBuildInputs = nativeBuildInputs ++ [ pkg-config ];
      buildInputs = buildInputs ++ [ getdns ];
    };

  hashlib = lockAttrs:
    lib.trivial.warnIf
      (lockAttrs.rev == "84e0247555e4488594975900401baaf5bbbfb531")
      "the selected version of the hashlib Nim library is hardware specific"
      # https://github.com/khchen/hashlib/pull/4
      # remove when fixed upstream
      (_: _: { });

  nimraylib_now = lockAttrs: finalAttrs:
    { buildInputs ? [ ], ... }: {
      buildInputs = buildInputs ++ [ raylib ];
    };

  sass = lockAttrs: finalAttrs:
    { buildInputs ? [ ], ... }: {
      buildInputs = buildInputs ++ [ libsass ];
    };

  sdl2 = lockAttrs: finalAttrs:
    { buildInputs ? [ ], ... }: {
      buildInputs = buildInputs ++ [ SDL2 ];
    };

  tkrzw = lockAttrs: finalAttrs:
    { nativeBuildInputs ? [ ], buildInputs ? [ ], ... }: {
      nativeBuildInputs = nativeBuildInputs ++ [ pkg-config ];
      buildInputs = buildInputs ++ [ tkrzw ];
    };

  x11 = lockAttrs: finalAttrs:
    { buildInputs ? [ ], ... }: {
      buildInputs = buildInputs ++ (with xorg; [ libX11 libXft libXinerama ]);
    };

  zippy = lockAttrs: finalAttrs:
    { nimFlags ? [ ], ... }: {
      nimFlags = nimFlags ++ lib.optionals stdenv.hostPlatform.isx86_64 [
        "--passC:-msse4.1"
        "--passC:-mpclmul"
      ];
    };
}
