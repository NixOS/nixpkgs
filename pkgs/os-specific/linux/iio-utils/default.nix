{
  lib,
  stdenv,
  kernel,
}:

stdenv.mkDerivation {
  pname = "iio-utils";
  inherit (kernel) src version;

  makeFlags = [ "bindir=${placeholder "out"}/bin" ];

  postPatch = ''
    cd tools/iio
  '';

  meta = {
    description = "Userspace tool for interacting with Linux IIO";
    homepage = "https://www.kernel.org/";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
  };
}
