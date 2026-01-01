{
  lib,
  stdenv,
  kernel,
  libcap,
}:

stdenv.mkDerivation {
  pname = "turbostat";
  inherit (kernel) src version;

  buildInputs = [ libcap ];
  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  postPatch = ''
    cd tools/power/x86/turbostat
  '';

<<<<<<< HEAD
  meta = {
    description = "Report processor frequency and idle statistics";
    mainProgram = "turbostat";
    homepage = "https://www.kernel.org/";
    license = lib.licenses.gpl2Only;
=======
  meta = with lib; {
    description = "Report processor frequency and idle statistics";
    mainProgram = "turbostat";
    homepage = "https://www.kernel.org/";
    license = licenses.gpl2Only;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    platforms = [
      "i686-linux"
      "x86_64-linux"
    ]; # x86-specific
  };
}
