{ lib, fetchurl, buildPythonPackage, python, isPyPy, sip-module ? "sip" }:

buildPythonPackage rec {
  pname = sip-module;
  version = "4.19.23";
  format = "other";

  disabled = isPyPy;

  src = fetchurl {
    url = "https://www.riverbankcomputing.com/static/Downloads/sip/${version}/sip-${version}.tar.gz";
    sha256 = "sha256-IsqbzsU4gRTkDUqv18zQxP4HIpe2KNDFzfovAQwLx+c=";
  };

  configurePhase = ''
    ${python.executable} ./configure.py \
      --sip-module ${sip-module} \
      -d $out/${python.sitePackages} \
      -b $out/bin -e $out/include
  '';

  enableParallelBuilding = true;

  installCheckPhase = let
    modules = [
      sip-module
      "sipconfig"
    ];
    imports = lib.concatMapStrings (module: "import ${module};") modules;
  in ''
    echo "Checking whether modules can be imported..."
    PYTHONPATH=$out/${python.sitePackages}:$PYTHONPATH ${python.interpreter} -c "${imports}"
  '';

  doCheck = true;

  meta = with lib; {
    description = "Creates C++ bindings for Python modules";
    homepage    = "http://www.riverbankcomputing.co.uk/";
    license     = licenses.gpl2Plus;
    maintainers = with maintainers; [ lovek323 sander ];
    platforms   = platforms.all;
  };
}
