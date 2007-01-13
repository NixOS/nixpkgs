{stdenv, fetchurl, libpcap}:
  
stdenv.mkDerivation {
  name = "p0f-2.0.8";
  
  src = fetchurl {
    url = http://lcamtuf.coredump.cx/p0f/p0f-2.0.8.tgz;
    md5 = "1ccbcd8d4c95ef6dae841120d23c56a5";
  };
  
  buildInputs = [libpcap];
  patches = [./p0f.patch];
}
