{ stdenv, fetchurl, zlib }:

stdenv.mkDerivation rec {
  name = "kexec-tools-2.0.9";

  src = fetchurl {
    url = "http://horms.net/projects/kexec/kexec-tools/${name}.tar.xz";
    sha256 = "0wag8pxn13i0j91x2bszpmi5i88xnndcmqz1w5a0jdbnxff4mqwa";
  };

  buildInputs = [ zlib ];

  meta = with stdenv.lib; {
    homepage = http://horms.net/projects/kexec/kexec-tools;
    description = "Tools related to the kexec Linux feature";
    platforms = with platforms; linux;
    maintainers = with maintainers; [ nckx ];
  };
}
