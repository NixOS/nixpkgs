{ stdenv, fetchsvn, fetchurl, cups, cups-filters, jbigkit, zlib }:

let
  rev = "315";

  color-profiles = stdenv.mkDerivation {
    name = "splix-color-profiles-20070625";

    src = fetchurl {
      url = "http://splix.ap2c.org/samsung_cms.tar.bz2";
      sha256 = "1156flics5m9m7a4hdmcc2nphbdyary6dfmbcrmsp9xb7ivsypdl";
    };

    phases = [ "unpackPhase" "installPhase" ];

    installPhase = ''
      mkdir -p $out/share/cups/profiles/samsung
      cp * $out/share/cups/profiles/samsung/
    '';
  };

in stdenv.mkDerivation {
  name = "splix-svn-${rev}";

  src = fetchsvn {
    # We build this from svn, because splix hasn't been in released in several years
    # although the community has been adding some new printer models.
    url = "svn://svn.code.sf.net/p/splix/code/splix";
    rev = "r${rev}";
    sha256 = "16wbm4xnz35ca3mw2iggf5f4jaxpyna718ia190ka6y4ah932jxl";
  };

  postPatch = ''
    substituteInPlace src/pstoqpdl.cpp \
      --replace "RASTERDIR \"/\" RASTERTOQPDL" "\"$out/lib/cups/filter/rastertoqpdl\"" \
      --replace "RASTERDIR" "\"${cups-filters}/lib/cups/filter\"" \
  '';

  makeFlags = [
    "CUPSFILTER=$(out)/lib/cups/filter"
    "CUPSPPD=$(out)/share/cups/model"
    "CUPSPROFILE=${color-profiles}/share/cups/profiles"
  ];

  buildInputs = [ cups zlib jbigkit ];

  meta = with stdenv.lib; {
    description = "CUPS drivers for SPL (Samsung Printer Language) printers";
    homepage = http://splix.ap2c.org;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ jfrankenau peti ];
  };
}
