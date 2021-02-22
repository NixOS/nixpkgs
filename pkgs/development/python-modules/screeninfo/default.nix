{ lib, buildPythonApplication, fetchPypi, isPy27, isPy36, dataclasses, libX11, libXinerama, libXrandr }:

buildPythonApplication rec {
  pname = "screeninfo";
  version = "0.6.6";
  disabled = isPy27; # dataclasses isn't available for python2

  src = fetchPypi {
    inherit pname version;
    sha256 = "c93fcc3c9421cc2046e57468241c4c08c0c6cffd0e05a85cb0b18de8fe8b026f";
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

  propagatedBuildInputs = lib.optional isPy36 dataclasses;

  buildInputs = [ libX11 libXinerama libXrandr];

  meta = with lib; {
    description = "Fetch location and size of physical screens";
    homepage = "https://github.com/rr-/screeninfo";
    license = licenses.mit;
    maintainers = [ maintainers.nickhu ];
  };
}
