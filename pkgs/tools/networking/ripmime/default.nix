{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "ripmime";
  version = "1.4.0.10";
  src = fetchurl {
    url = "http://www.pldaniels.com/${pname}/${name}.tar.gz";
    sha256 = "0sj06ibmlzy34n8v0mnlq2gwidy7n2aqcwgjh0xssz3vi941aqc9";
  };

  preInstall = ''
    sed -i Makefile -e "s@LOCATION=.*@LOCATION=$out@" -e "s@man/man1@share/&@"
    mkdir -p "$out/bin" "$out/share/man/man1"
  '';

  NIX_CFLAGS_COMPILE=" -Wno-error ";

  meta = with stdenv.lib; {
    description = "Attachment extractor for MIME messages";
    maintainers = with maintainers; [ raskin ];
    homepage = http://www.pldaniels.com/ripmime/;
    platforms = platforms.linux;
  };

  passthru = {
    updateInfo = {
      downloadPage = "http://www.pldaniels.com/ripmime/";
    };
  };
}
