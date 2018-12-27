{ lib, fetchurl, buildPythonPackage, python, isPyPy
, sipModule ? "sip"
, withModule ? true
, withTools ? sipModule == "sip"
}:

buildPythonPackage rec {
  pname = sipModule;
  version = "4.19.13";
  format = "other";

  disabled = isPyPy;

  src = fetchurl {
    url = "mirror://sourceforge/pyqt/sip/sip-${version}/sip-${version}.tar.gz";
    sha256 = "0pniq03jk1n5bs90yjihw3s3rsmjd8m89y9zbnymzgwrcl2sflz3";
  };

  nativeBuildInputs = [ python ];

  configureScript = "python configure.py";

  configureFlags = (
    if (!withModule) then [ "--no-module" ] else [
      "--sip-module" sipModule
      "-d" "${placeholder "out"}/${python.sitePackages}"
    ]
  ) ++ (
    if (!withTools) then [ "--no-tools" ] else [
      "-b" "${placeholder "out"}/bin"
      "-e" "${placeholder "out"}/include"
    ]
  );

  dontAddPrefix = true;

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Creates C++ bindings for Python modules";
    homepage    = "http://www.riverbankcomputing.co.uk/";
    license     = licenses.gpl2Plus;
    maintainers = with maintainers; [ lovek323 sander ];
    platforms   = platforms.all;
  };
}
