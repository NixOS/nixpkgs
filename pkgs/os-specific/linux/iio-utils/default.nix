{ lib, stdenv, kernel }:

stdenv.mkDerivation {
  pname = "iio-utils";
  inherit (kernel) src version;

  makeFlags = [ "bindir=${placeholder "out"}/bin" ];

  postPatch = ''
    cd tools/iio
  '';

  meta = with lib; {
    description = "Userspace tool for interacting with Linux IIO";
    homepage = "https://www.kernel.org/";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
  };
}
