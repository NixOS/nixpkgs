{ lib, stdenv, fetchurl, fetchpatch, cmake, pkg-config, qt4, taglib, chromaprint, ffmpeg_4 }:

stdenv.mkDerivation rec {
  pname = "acoustid-fingerprinter";
  version = "0.6";

  src = fetchurl {
    url = "https://bitbucket.org/acoustid/acoustid-fingerprinter/downloads/"
        + "${pname}-${version}.tar.gz";
    sha256 = "0ckglwy95qgqvl2l6yd8ilwpd6qs7yzmj8g7lnxb50d12115s5n0";
  };

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ qt4 taglib chromaprint ffmpeg_4 ];

  cmakeFlags = [ "-DTAGLIB_MIN_VERSION=${lib.getVersion taglib}" ];

  patches = [
    (fetchpatch {
      name = "fix-build-with-libav-10.patch";
      url = "https://bitbucket.org/acoustid/acoustid-fingerprinter/commits/2c778334a9fc2f0ccf9b1d7635c116bce6509748/raw";
      sha256 = "1smyp3x5n6jwxpgw60xsijq2fn6g1gl759h1lm5agaxhcyyqn0i0";
    })
    (fetchpatch {
      name = "fix-build-failure-on-gcc-6.patch";
      url = "https://bitbucket.org/acoustid/acoustid-fingerprinter/commits/632e87969c3a5562a5d4842b03613267ba6236b2/raw";
      sha256 = "15hm9knrpqn3yqrwyjz4zh2aypwbcycd0c5svrsy1fb2h2rh05jk";
    })
  ];

  meta = with lib; {
    homepage = "https://acoustid.org/fingerprinter";
    description = "Audio fingerprinting tool using chromaprint";
    license = lib.licenses.gpl2Plus;
    maintainers = with maintainers; [ ehmry ];
    platforms = with platforms; linux;
  };
}
