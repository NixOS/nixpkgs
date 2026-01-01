{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "apache-felix";
  version = "7.0.5";
  src = fetchurl {
    url = "mirror://apache/felix/org.apache.felix.main.distribution-${version}.tar.gz";
    sha256 = "sha256-N9mbkIzMkMV2RLONv15EiosJxMU9iEJvwPWEauPIEe8=";
  };
  buildCommand = ''
    tar xfvz $src
    cd felix-framework-*
    mkdir -p $out
    cp -av * $out
  '';
<<<<<<< HEAD
  meta = {
    description = "OSGi gateway";
    homepage = "https://felix.apache.org";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license = lib.licenses.asl20;
=======
  meta = with lib; {
    description = "OSGi gateway";
    homepage = "https://felix.apache.org";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.asl20;
    maintainers = [ maintainers.sander ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "felix.jar";
  };
}
