{ stdenv, lib, go, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "fleet-${version}";
  version = "0.11.8";

  src = fetchFromGitHub {
    owner = "coreos";
    repo = "fleet";
    rev = "v${version}";
    sha256 = "13kwaa4hkiic602wnvnk13pflrxqhk2vxwpk1bn52ilwxkjyvkig";
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
