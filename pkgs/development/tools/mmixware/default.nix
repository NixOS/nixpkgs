{ lib, stdenv, fetchFromGitLab, tetex }:

stdenv.mkDerivation {
  pname = "mmixware";
  version = "unstable-2021-06-18";

  src = fetchFromGitLab {
    domain = "gitlab.lrz.de";
    owner = "mmix";
    repo = "mmixware";
    rev = "7c790176d50d13ae2422fa7457ccc4c2d29eba9b";
    sha256 = "sha256-eSwHiJ5SP/Nennalv4QFTgVnM6oan/DWDZRqtk0o6Z0=";
  };

  hardeningDisable = [ "format" ];

  postPatch = ''
    substituteInPlace Makefile --replace 'rm abstime.h' ""
  '';

  # Workaround build failure on -fno-common toolchains:
  #   ld: mmix-config.o:(.bss+0x600): multiple definition of `buffer'; /build/ccDuGrwH.o:(.bss+0x20): first defined here
  NIX_CFLAGS_COMPILE = "-fcommon";

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
