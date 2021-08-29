{ lib, stdenv, fetchFromGitLab, tetex }:

stdenv.mkDerivation {
  pname = "mmixware";
  version = "unstable-2019-02-19";

  src = fetchFromGitLab {
    domain = "gitlab.lrz.de";
    owner = "mmix";
    repo = "mmixware";
    rev = "a330d68aafcfe739ecaaece888a669b8e7d9bcb8";
    sha256 = "0bq0d19vqhfbpk4mcqzmd0hygbkhapl1mzlfkcr6afx0fhlhi087";
  };

  hardeningDisable = [ "format" ];

  postPatch = ''
    substituteInPlace Makefile --replace 'rm abstime.h' ""
  '';

  nativeBuildInputs = [ tetex ];
  enableParallelBuilding = true;

  makeFlags = [ "all" "doc" "CFLAGS=-O2" ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/doc
    cp *.ps $out/share/doc
    install -Dm755 mmixal -t $out/bin
    install -Dm755 mmix -t $out/bin
    install -Dm755 mmotype -t $out/bin
    install -Dm755 mmmix -t $out/bin
    runHook postInstall
  '';

  meta = with lib; {
    description  = "MMIX simulator and assembler";
    homepage     = "https://www-cs-faculty.stanford.edu/~knuth/mmix-news.html";
    maintainers  = with maintainers; [ siraben ];
    platforms    = platforms.unix;
    license      = licenses.publicDomain;
  };
}
