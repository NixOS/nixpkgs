{ lib, stdenv, fetchpatch, fetchurl, nettle }:

stdenv.mkDerivation rec {
  pname = "rdfind";
  version = "1.5.0";

  src = fetchurl {
    url = "https://rdfind.pauldreik.se/${pname}-${version}.tar.gz";
    sha256 = "103hfqzgr6izmj57fcy4jsa2nmb1ax43q4b5ij92pcgpaq9fsl21";
  };

  patches = [
    (fetchpatch {
      name = "include-limits.patch";
      url = "https://github.com/pauldreik/rdfind/commit/61877de88d782b63b17458a61fcc078391499b29.patch";
      sha256 = "0igzm4833cn905pj84lgr88nd5gx35dnjl8kl8vrwk7bpyii6a8l";
    })
  ];

  buildInputs = [ nettle ];

  meta = with lib; {
    homepage = "https://rdfind.pauldreik.se/";
    description = "Removes or hardlinks duplicate files very swiftly";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.wmertens ];
    platforms = platforms.all;
  };
}
