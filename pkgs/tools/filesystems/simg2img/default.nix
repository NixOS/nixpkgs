{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "simg2img";
  version = "1.1.4";

  src = fetchFromGitHub {
    owner = "anestisb";
    repo = "android-simg2img";
    rev = version;
    sha256 = "1xm9kaqs2w8c7a4psv78gv66gild88mpgjn5lj087d7jh1jxy7bf";
  };

  buildInputs = [ zlib ];

  makeFlags = [
    "PREFIX=$(out)"
    "DEP_CXX:=$(CXX)"
  ];

  patches = [
    (fetchpatch {
      name = "PR-38-Fix-for-Apple-Silicon.patch";
      url = "https://github.com/anestisb/android-simg2img/commit/931df9dd83e7feea11197402c5b4e7ad489f4abf.patch";
      hash = "sha256-+vHdx+nwaeaLf7a/hZSAVECc/Q5nQ1G2i0eTOVHb8Ks=";
    })
  ];

  meta = with lib; {
    description = "Tool to convert Android sparse images to raw images";
    homepage = "https://github.com/anestisb/android-simg2img";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [
      dezgeg
      arkivm
    ];
  };
}
