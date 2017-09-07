{ stdenv, fetchurl, cmake, patchelf, imagemagick }:

stdenv.mkDerivation rec {
  name = "cuneiform-${version}";
  version = "1.1.0";

  src = fetchurl {
    url = "https://launchpad.net/cuneiform-linux/1.1/1.1/+download/cuneiform-linux-1.1.0.tar.bz2";
    sha256 = "1bdvppyfx2184zmzcylskd87cxv56d8f32jf7g1qc8779l2hszjp";
  };

  patches = [
  (fetchurl {
    url = "https://git.archlinux.org/svntogit/community.git/plain/cuneiform/trunk/build-fix.patch?id=a2ec92f05de006b56d16ac6a6c370d54a554861a";
    sha256 = "19cmrlx4khn30qqrpyayn7bicg8yi0wpz1x1bvqqrbvr3kwldxyj";
  })
  ];

  buildInputs = [ imagemagick ];

  nativeBuildInputs = [ cmake ];

  meta = {
    description = "Multi-language OCR system";
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [raskin];
  };
}
