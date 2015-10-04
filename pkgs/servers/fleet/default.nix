{ stdenv, lib, go, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "fleet-${version}";
  version = "0.11.2";

  src = fetchFromGitHub {
    owner = "coreos";
    repo = "fleet";
    rev = "v${version}";
    sha256 = "00qkhbm9l1grchri80rmg7a9q4dbmxhkw50klmn3bwskxyzb04gr";
  };

  buildInputs = [ go ];

  buildPhase = ''
    patchShebangs build
    ./build
  '';

  installPhase = ''
    mkdir -p $out
    mv bin $out
  '';

  meta = with stdenv.lib; {
    description = "A distributed init system";
    homepage = http://coreos.com/using-coreos/clustering/;
    license = licenses.asl20;
    maintainers = with maintainers; [ cstrahan offline ];
    platforms = platforms.unix;
  };
}
