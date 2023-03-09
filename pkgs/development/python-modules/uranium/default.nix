{ lib, buildPythonPackage, fetchFromGitHub, python, cmake
, fetchpatch
, pyqt5, numpy, scipy, shapely, libarcus, cryptography, doxygen, gettext, pythonOlder }:

buildPythonPackage rec {
  version = "5.2.0";
  pname = "uranium";
  format = "other";

  src = fetchFromGitHub {
    owner = "Ultimaker";
    repo = "Uranium";
    rev = version;
    sha256 = "07npd2067zz968snw8gjazaibmqp5vjspd6k4nysglpsnfd9bfsj";
  };

  patches = [
    # Imported from Alpine:
    (fetchpatch {
      url = "https://git.alpinelinux.org/aports/plain/testing/uranium/cmake-helpers.patch?id=7972f49701755aacaace54a72605176cba896999";
      name = "uranium-cmake-helpers.patch";
      sha256 = "0ivawvf4kyhwspz1jyvy7xb3s6lfhzg3dynnh82ax95nj6rzmi6p";
    })
    # Imported from Alpine:
    (fetchpatch {
      url = "https://git.alpinelinux.org/aports/plain/testing/uranium/cmake.patch?id=7972f49701755aacaace54a72605176cba896999";
      name = "uranium-cmake.patch";
      sha256 = "145wgq32hh1gjcnnhnfcm8mzg3fgcv36zxmdjsg25sssbsc73vbk";
    })
  ];

  disabled = pythonOlder "3.5.0";

  buildInputs = [ python gettext ];
  propagatedBuildInputs = [ pyqt5 numpy scipy shapely libarcus cryptography ];
  nativeBuildInputs = [ cmake doxygen ];

  postPatch = lib.concatStrings [
    # See comment on setting of `-DPython_SITELIB_LOCAL` below.
    ''
      sed -i \
        -e "s,Python_SITELIB,Python_SITELIB_LOCAL," \
        CMakeLists.txt
    ''
    # `uranium`'s relative search paths need to be fixed because these
    # python files are installed in `$PREFIX/lib/python3.10/site-packages/UM/`
    # but the dirs they seek are in `$PREFIX/share/` and `$PREFIX/lib/uranium/`.
    ''
      sed -i \
       -e "s,Resources.addSearchPath(str(Path(__file__).parent.parent.joinpath("resources"))),Resources.addSearchPath(\"$out/share/uranium/resources\")," \
       -e "s,self._plugin_registry.addPluginLocation(str(Path(__file__).parent.parent.joinpath("plugins"))),self._plugin_registry.addPluginLocation(\"$out/lib/uranium/plugins\")," \
       UM/Application.py
    ''
  ];

  cmakeFlags = [
    # Set install location to not be the global Python install dir
    # (which is read-only in the nix store); see:
    # Note the `cmake.patch` above changes the variable that needs to be set
    # from `Python_SITELIB_LOCAL` to `Python_SITELIB`,
    # and our `postPatch` above undoes that, because otherwise we get error:
    #     CMake Error at cmake_install.cmake:53 (file):
    #       file INSTALL cannot make directory
    #       "/nix/store/al6g1zbk8li6p8mcyp0h60d08jaahf8c-python3-3.10.9/lib/python3.10/site-packages/UM":
    #       Permission denied.
    "-DPython_SITELIB_LOCAL=${placeholder "out"}/${python.sitePackages}"

    # Fixes cmake warning `GETTEXT_MSGINIT_EXECUTABLE is undefined!`
    "-DGETTEXT_MSGINIT_EXECUTABLE=msginit"

    # Fixes cmake warning about its absence.
    "-DCURA_BINARY_DATA_DIRECTORY=${placeholder "out"}/share/cuda"
  ];

  meta = with lib; {
    description = "A Python framework for building Desktop applications";
    homepage = "https://github.com/Ultimaker/Uranium";
    license = licenses.lgpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar gebner ];
  };
}
