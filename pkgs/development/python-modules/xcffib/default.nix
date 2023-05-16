{ lib
, buildPythonPackage
<<<<<<< HEAD
, cffi
, fetchPypi
, pytestCheckHook
, pythonOlder
, xorg
}:

buildPythonPackage rec {
  pname = "xcffib";
  version = "1.5.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-qVyUZfL5e0/O3mBr0eCEB6Mt9xy3YP1Xv+U2d9tpGsw=";
  };

=======
, fetchPypi
, fetchpatch
, xorg
, cffi
, pytestCheckHook
}:

buildPythonPackage rec {
  version = "1.2.0";
  pname = "xcffib";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-8yMCFEf55zB40hu5KMSPTavq6z87N+gDxta5hzXoFIM=";
  };

  patches = [
    (fetchpatch {
      name = "remove-leftover-six-import.patch";
      url = "https://github.com/tych0/xcffib/commit/8a488867d30464913706376ca3a9f4c98ca6c5cf.patch";
      hash = "sha256-wEms0gC7tVqtmKMjjpH/34kdQ6HUV0h67bUGbgijlqw=";
    })
  ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  postPatch = ''
    # Hardcode cairo library path
    sed -e 's,ffi\.dlopen(,&"${xorg.libxcb.out}/lib/" + ,' -i xcffib/__init__.py
  '';

<<<<<<< HEAD
  propagatedNativeBuildInputs = [
    cffi
  ];

  propagatedBuildInputs = [
    cffi
  ];
=======
  propagatedBuildInputs = [ cffi ];

  propagatedNativeBuildInputs = [ cffi ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeCheckInputs = [
    pytestCheckHook
    xorg.xeyes
    xorg.xorgserver
  ];

  preCheck = ''
    # import from $out
    rm -r xcffib
  '';

<<<<<<< HEAD
  pythonImportsCheck = [
    "xcffib"
  ];
=======
  pythonImportsCheck = [ "xcffib" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "A drop in replacement for xpyb, an XCB python binding";
    homepage = "https://github.com/tych0/xcffib";
<<<<<<< HEAD
    changelog = "https://github.com/tych0/xcffib/releases/tag/v${version}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.asl20;
    maintainers = with maintainers; [ kamilchm ];
  };
}
