{ lib
, stdenv
, fetchFromGitHub
, cups
, coreutils
, nixosTests
}:

stdenv.mkDerivation rec {
  pname = "cups-pdf-to-pdf";
  version = "unstable-2021-12-22";

  src = fetchFromGitHub {
    owner = "alexivkin";
    repo = "CUPS-PDF-to-PDF";
    rev = "c14428c2ca8e95371daad7db6d11c84046b1a2d4";
    hash = "sha256-pa4PFf8OAFSra0hSazmKUfbMYL/cVWvYA1lBf7c7jmY=";
  };

  buildInputs = [ cups ];

  postPatch = ''
    sed -r 's|(gscall, size, ")cp |\1${coreutils}/bin/cp |' cups-pdf.c -i
  '';

  # gcc command line is taken from original cups-pdf's README file
  # https://fossies.org/linux/cups-pdf/README
  # however, we replace gcc with $CC following
  # https://nixos.org/manual/nixpkgs/stable/#sec-darwin
  buildPhase = ''
    runHook preBuild
    $CC -O9 -s cups-pdf.c -o cups-pdf -lcups
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dt $out/lib/cups/backend cups-pdf
    install -Dm 0644 -t $out/etc/cups cups-pdf.conf
    install -Dm 0644 -t $out/share/cups/model *.ppd
    runHook postInstall
  '';

  passthru.tests.vmtest = nixosTests.cups-pdf;

  meta = with lib; {
    description = "A CUPS backend that turns print jobs into searchable PDF files";
    homepage = "https://github.com/alexivkin/CUPS-PDF-to-PDF";
    license = licenses.gpl2Only;
    maintainers = [ maintainers.yarny ];
    longDescription = ''
      cups-pdf is a CUPS backend that generates a PDF file for each print job and puts this file
      into a folder on the local machine such that the print job's owner can access the file.

      https://www.cups-pdf.de/

      cups-pdf-to-pdf is a fork of cups-pdf which tries hard to preserve the original text of the print job by avoiding rasterization.

      Note that in order to use this package, you have to make sure that the cups-pdf program is called with root privileges.
    '';
  };
}
