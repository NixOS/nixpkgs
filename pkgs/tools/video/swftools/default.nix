{ lib, stdenv, fetchurl, freetype, libjpeg, zlib }:

stdenv.mkDerivation rec {
  pname = "swftools";
  version = "0.9.2";

  src = fetchurl {
    url = "http://www.swftools.org/${pname}-${version}.tar.gz";
    sha256 = "1w81dyi81019a6jmnm5z7fzarswng27lg1d4k4d5llxzqszr2s5z";
  };

  patches = [ ./swftools.patch ];

  buildInputs = [ freetype libjpeg zlib ];

  meta = with lib; {
    description = "Collection of SWF manipulation and creation utilities";
    homepage = "http://www.swftools.org/about.html";
    license = licenses.gpl2Only;
    maintainers = [ maintainers.koral ];
    platforms = lib.platforms.unix;
    knownVulnerabilities = [
      "CVE-2017-10976"
      "CVE-2017-11096"
      "CVE-2017-11097"
      "CVE-2017-11098"
      "CVE-2017-11099"
      "CVE-2017-11100"
      "CVE-2017-11101"
      "CVE-2017-16711"
      "CVE-2017-16793"
      "CVE-2017-16794"
      "CVE-2017-16796"
      "CVE-2017-16797"
      "CVE-2017-16868"
      "CVE-2017-16890"
    ];
  };
}
