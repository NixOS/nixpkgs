{ stdenv, lib, go, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "fleet-${version}";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "coreos";
    repo = "fleet";
    rev = "v${version}";
    sha256 = "0j48ajz19aqfzv9iyznnn39aw51y1nqcl270grmvi5cbqycmrfm0";
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
    homepage = https://coreos.com/using-coreos/clustering/;
    license = licenses.asl20;
    maintainers = with maintainers; [
      cstrahan
      jgeerds
      offline
    ];
    platforms = platforms.unix;
  };
}
