{ stdenv, fetchurl, zlib, xz}:

stdenv.mkDerivation {
  name = "kexectools-2.0.3";
  
  src = fetchurl {
    url = http://horms.net/projects/kexec/kexec-tools/kexec-tools-2.0.3.tar.xz;
    sha256 = "1ac6szvm6pdhn5b8ba5l06rx09rylsqhgv1l6wmy4b5b1hrbip52";
  };

  buildInputs = [ xz zlib ];
  
  meta = {
    homepage = http://horms.net/projects/kexec/kexec-tools/;
    description = "Tools related to the kexec linux feature";
  };
}
