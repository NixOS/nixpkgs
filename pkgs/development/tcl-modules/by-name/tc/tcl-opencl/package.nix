{
  lib,
  mkTclDerivation,
  fetchFromGitHub,
  opencl-headers,
  ocl-icd,
  vectcl,
}:

mkTclDerivation rec {
  pname = "tcl-opencl";
  version = "0.8";

  src = fetchFromGitHub {
    owner = "ray2501";
    repo = "tcl-opencl";
    tag = version;
    hash = "sha256-nVqHWP6YbWbOAJsz0+4xYkOW3zWVmwhOI421Ak+8E3Q=";
  };

  buildInputs = [
    ocl-icd
    opencl-headers
  ];

  propagatedBuildInputs = [
    vectcl
  ];

  configureFlags = [
    "--with-vectcl=${vectcl}/lib/vectcl${vectcl.version}"
  ];

  meta = {
    homepage = "https://github.com/ray2501/tcl-opencl";
    description = "Tcl extension for OpenCL";
    maintainers = with lib.maintainers; [ fgaz ];
    license = lib.licenses.mit;
  };
}
