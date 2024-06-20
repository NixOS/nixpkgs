{ stdenv
, lib
, fetchFromGitHub
, cmake
, cups
}:
stdenv.mkDerivation {
  pname = "rastertokpsl";
  version = "2019-12-19";

  src = fetchFromGitHub {
    owner = "sv99";
    repo = "rastertokpsl-re";
    rev = "84dcb2bc0d9a6797eedcd56f2e603dde2fbbf290";
    hash = "sha256-qPBZ0qKnY14rTaNa6vjyVB8c0aaXDSewia4n1a6xoyg=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ cups ];

  installPhase = ''
    runHook preInstall

    pushd ..

    install -d "$out/bin"
    install -m 755 bin/rastertokpsl-re "$out/bin/rastertokpsl"

    popd

    runHook postInstall
  '';

  meta = with lib; {
    description = "Reverse-engineered Kyocera KPSL CUPS filter for various GDI printers";
    homepage = "https://github.com/sv99/rastertokpsl-re";
    license = licenses.asl20;
    maintainers = [ maintainers.veehaitch ];
    platforms = platforms.linux;
  };
}
