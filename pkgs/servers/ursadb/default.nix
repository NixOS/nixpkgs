{ stdenv, fetchurl, cmake, zeromq, cppzmq }:

stdenv.mkDerivation {
  name = "ursadb";
  version = "1.2.0";

  src = fetchurl {
    url = "https://github.com/CERT-Polska/ursadb/archive/v1.2.0.tar.gz";
    sha256 = "10dax3mswq0x4cfrpi31b7ii7bxl536wz1j11b7f5c0zw9pjxzym";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp ursadb $out/bin/
    cp ursadb_new $out/bin/
    cp ursadb_trim $out/bin/
  '';

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    zeromq
    cppzmq
  ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/CERT-Polska/ursadb";
    description = "Trigram database written in C++, suited for malware indexing";
    license = licenses.bsd3;
    maintainers = with maintainers; [ msm ];
    platforms = platforms.unix;
  };
}
