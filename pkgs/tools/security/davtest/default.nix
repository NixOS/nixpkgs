{ lib, stdenv, perl, fetchurl }:

stdenv.mkDerivation rec {
  pname = "davtest";
  version = "1.0";

  src = fetchurl {
    url = "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/davtest/davtest-${version}.tar.bz2";
    sha256 = "0kigcgv1bbnan9yr5481s4b9islmvzl2arpg1ig1i39sxrna06y7";
  };

  postPatch = ''
    substituteInPlace davtest.pl \
      --replace "backdoors/" "$out/share/davtest/backdoors/" \
      --replace "tests/" "$out/share/davtest/tests/"
  '';

  buildInputs = [
    (perl.withPackages (p: with p; [ HTTPDAV ]))
  ];

  installPhase = ''
    runHook preInstall

    install -Dm755 davtest.pl $out/bin/davtest.pl
    mkdir -p $out/share/davtest
    cp -r backdoors/ tests/ $out/share/davtest/

    runHook postInstall
  '';

  meta = with lib; {
    description = "Tests WebDAV servers by uploading test files, and then optionally testing for command execution or other actions directly on the target";
    homepage = "https://code.google.com/p/davtest/";
    mainProgram = "davtest.pl";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ emilytrau ];
    platforms = platforms.unix;
  };
}
