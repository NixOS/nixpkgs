{ lib
, stdenv
, fetchurl
, tk
, tcllib
, tcl
, tkremind ? true
}:

tcl.mkTclDerivation rec {
  pname = "remind";
  version = "05.00.01";

  src = fetchurl {
    url = "https://dianne.skoll.ca/projects/remind/download/remind-${version}.tar.gz";
    hash = "sha256-tj36/lLn67/hkNMrRVGXRLqQ9Sx6oDKZHeajiSYn97c=";
  };

  propagatedBuildInputs = lib.optionals tkremind [ tcllib tk ];

  postPatch = lib.optionalString tkremind ''
    # NOTA BENE: The path to rem2pdf is replaced in tkremind for future use
    # as rem2pdf is currently not build since it requires the JSON::MaybeXS,
    # Pango and Cairo Perl modules.
    substituteInPlace scripts/tkremind \
      --replace-fail "exec wish" "exec ${lib.getBin tk}/bin/wish" \
      --replace-fail 'set Remind "remind"' "set Remind \"$out/bin/remind\"" \
      --replace-fail 'set Rem2PS "rem2ps"' "set Rem2PS \"$out/bin/rem2ps\"" \
      --replace-fail 'set Rem2PDF "rem2pdf"' "set Rem2PDF \"$out/bin/rem2pdf\""
  '';

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.isDarwin (toString [
    # Disable clang link time optimization until the following issue is resolved:
    # https://github.com/NixOS/nixpkgs/issues/19098
    "-fno-lto"
    # On Darwin setenv and unsetenv are defined in stdlib.h from libSystem
    "-DHAVE_SETENV"
    "-DHAVE_UNSETENV"
  ]);

  meta = with lib; {
    homepage = "https://dianne.skoll.ca/projects/remind/";
    description = "Sophisticated calendar and alarm program for the console";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ raskin kovirobi ];
    mainProgram = "remind";
    platforms = platforms.unix;
  };
}
