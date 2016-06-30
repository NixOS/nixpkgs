{ stdenv, lib, fetchFromGitHub
, coreutils, gmp, opencl-headers, opencl-icd, makeWrapper
}:

stdenv.mkDerivation rec {
  name    = "hashcat-${version}";
  version = "3.00";

  src = fetchFromGitHub {
    owner  = "hashcat";
    repo   = "hashcat";
    rev    = "v${version}";
    sha256 = "1rjy5p41g3l51s4aiv94ks7ghrhdh2209dw8gyv9cv3zii0ki545";
  };

  buildInputs = [ coreutils gmp opencl-headers opencl-icd makeWrapper ];

  buildPhase = ''
    # Set the PREFIX here to work around a bug in hashcat.
    # See https://github.com/hashcat/hashcat/issues/399
    make PREFIX=$out
  '';

  installPhase = ''
    make install PREFIX=$out
    wrapProgram $out/bin/hashcat \
      --prefix LD_LIBRARY_PATH : "${opencl-icd}/lib"

    mkdir -p $doc/share
    mv $out/share/doc $doc/share
  '';

  outputs = [ "out" "doc" ];

  meta = with lib; {
    description = "Fast password cracker";
    homepage    = http://hashcat.net/hashcat/;
    license     = licenses.mit;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ thoughtpolice zimbatm ];
  };
}
