{
  lib,
  fetchurl,
  fetchpatch,
  buildPythonPackage,
  python,
  isPyPy,
  pythonAtLeast,
  pythonOlder,
  sip-module ? "sip",
  setuptools,
}:

buildPythonPackage rec {
  pname = sip-module;
  version = "4.19.25";
  format = "other";

  disabled = isPyPy;

  src = fetchurl {
    url = "https://www.riverbankcomputing.com/static/Downloads/sip/${version}/sip-${version}.tar.gz";
    sha256 = "04a23cgsnx150xq86w1z44b6vr2zyazysy9mqax0fy346zlr77dk";
  };

  patches = lib.optionals (pythonAtLeast "3.11") [
    (fetchpatch {
      name = "sip-4-python3-11.patch";
      url = "https://aur.archlinux.org/cgit/aur.git/plain/python3-11.patch?h=sip4&id=67b5907227e68845cdfafcf050fedb89ed653585";
      sha256 = "sha256-cmuz2y5+T8EM/h03G2oboSnnOwrUjVKt2TUQaC9YAdE=";
    })
  ];

  postPatch = lib.optionalString (pythonAtLeast "3.12") ''
    substituteInPlace configure.py --replace-fail "from distutils" "from setuptools._distutils"
  '';

  propagatedBuildInputs = lib.optional (pythonAtLeast "3.12") setuptools;

  configurePhase = ''
    ${python.executable} ./configure.py \
      --sip-module ${sip-module} \
      -d $out/${python.sitePackages} \
      -b $out/bin -e $out/include
  '';

  enableParallelBuilding = true;

  pythonImportsCheck = [
    # https://www.riverbankcomputing.com/pipermail/pyqt/2023-January/045094.html
    # the import check for "sip" will fail, as it segfaults as the interperter is shutting down.
    # This is an upstream bug with sip4 on python3.12, and happens in the ubuntu packages version as well.
    # As the pacakge works fine until exit, just remove the import check for now.
    # See discussion at https://github.com/NixOS/nixpkgs/pull/327976#discussion_r1706488319
    (lib.optional (pythonOlder "3.12") sip-module)

    "sipconfig"
  ];

  doCheck = true;

  meta = with lib; {
    description = "Creates C++ bindings for Python modules";
    mainProgram = "sip";
    homepage = "https://riverbankcomputing.com/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [
      lovek323
      sander
    ];
    platforms = platforms.all;
  };
}
