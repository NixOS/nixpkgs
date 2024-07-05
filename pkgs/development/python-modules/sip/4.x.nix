{
  lib,
  fetchurl,
  fetchpatch,
  buildPythonPackage,
  python,
  isPyPy,
  pythonAtLeast,
  sip-module ? "sip",
}:

buildPythonPackage rec {
  pname = sip-module;
  version = "4.19.25";
  format = "other";

  # relies on distutils
  disabled = isPyPy || pythonAtLeast "3.12";

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

  configurePhase = ''
    ${python.executable} ./configure.py \
      --sip-module ${sip-module} \
      -d $out/${python.sitePackages} \
      -b $out/bin -e $out/include
  '';

  enableParallelBuilding = true;

  pythonImportsCheck = [
    sip-module
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
