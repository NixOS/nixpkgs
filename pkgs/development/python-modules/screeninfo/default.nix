{ stdenv, buildPythonApplication, fetchPypi, isPy36, dataclasses, libX11, libXinerama, libXrandr }:

buildPythonApplication rec {
  pname = "screeninfo";
  version = "0.6.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0vcw54crdgmbzwlrfg80kd1a8p9i10yks8k0szzi0k5q80zhp8xz";
  };

  # dataclasses is a compatibility shim for python 3.6 ONLY
  patchPhase = if isPy36 then "" else ''
    substituteInPlace setup.py \
      --replace "\"dataclasses\"," ""
  '' + ''
    substituteInPlace screeninfo/enumerators/xinerama.py \
      --replace "load_library(\"X11\")" "ctypes.cdll.LoadLibrary(\"${libX11}/lib/libX11.so\")" \
      --replace "load_library(\"Xinerama\")" "ctypes.cdll.LoadLibrary(\"${libXinerama}/lib/libXinerama.so\")"
    substituteInPlace screeninfo/enumerators/xrandr.py \
      --replace "load_library(\"X11\")" "ctypes.cdll.LoadLibrary(\"${libX11}/lib/libX11.so\")" \
      --replace "load_library(\"Xrandr\")" "ctypes.cdll.LoadLibrary(\"${libXrandr}/lib/libXrandr.so\")"
  '';

  propagatedBuildInputs = stdenv.lib.optional isPy36 dataclasses;

  buildInputs = [ libX11 libXinerama libXrandr];

  meta = with stdenv.lib; {
    description = "Fetch location and size of physical screens";
    homepage = "https://github.com/rr-/screeninfo";
    license = licenses.mit;
    maintainers = [ maintainers.nickhu ];
  };
}
