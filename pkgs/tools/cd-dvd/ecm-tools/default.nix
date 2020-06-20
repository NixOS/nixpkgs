{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "ecm-tools";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "alucryd";
    repo = "ecm-tools";
    rev = "v${version}";
    sha256 = "1rvyx5gcy8lfklgj80szlz3312x45wzx0d9jsgwyvy8f6m4nnb0c";
  };

  dontConfigure = true;

  installPhase = ''
    install --directory --mode=755 $out/bin
    install --mode=755 bin2ecm $out/bin
    (cd $out/bin; ln -s bin2ecm ecm2bin)
  '';

  meta = with stdenv.lib; {
    description = "A utility to uncompress ECM files to BIN CD format";
    homepage = "https://github.com/alucryd/ecm-tools";
    license = licenses.gpl3;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.all;
  };
}
