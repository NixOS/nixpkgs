{ stdenv, fetchurl, makeWrapper, opencl-headers, ocl-icd, xxHash }:

stdenv.mkDerivation rec {
  name    = "hashcat-${version}";
  version = "5.0.0";

  src = fetchurl {
    url = "https://hashcat.net/files/hashcat-${version}.tar.gz";
    sha256 = "13xh1lmzdppvx8wr8blqhdr8vpa24j099kz2xzb9pcnqy26dk4kh";
  };
  patches = [ ./use-installed-xxhash.patch ];

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ opencl-headers xxHash ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "OPENCL_HEADERS_KHRONOS=${opencl-headers}/include"
    "COMPTIME=1337"
    "VERSION_TAG=${version}"
  ];

  postFixup = ''
    wrapProgram $out/bin/hashcat --prefix LD_LIBRARY_PATH : ${ocl-icd}/lib
  '';

  meta = with stdenv.lib; {
    description = "Fast password cracker";
    homepage    = https://hashcat.net/hashcat/;
    license     = licenses.mit;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ kierdavis zimbatm ];
  };
}
