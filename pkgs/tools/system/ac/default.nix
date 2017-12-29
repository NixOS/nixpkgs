{ stdenv, fetchFromGitHub, ats }:

stdenv.mkDerivation rec {
  name = "ac-0.1.2";

  src = fetchFromGitHub {
    owner = "vmchale";
    repo = "fastcat";
    rev = "5031c47631ea5a31d4eb8a584c8226a698453125";
    sha256 = "1s7w07fnafksz5hspcnhkw4jpajibwyq0zv7m5jiywlwl9c7lxfj";
  };

  buildInputs = [ ats ];

  installPhase = ''
    mkdir -p $out/bin
    atscc src/ac.dats -o $out/bin/ac -O3
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/vmchale/fastcat;
    license = licenses.bsd3;
    maintainers = [];
  };
}
