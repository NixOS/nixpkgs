{ lib, stdenv, fetchFromGitHub, cmake, zlib, Cocoa }:

stdenv.mkDerivation rec {
  pname = "atomicparsley";
  version = "20210617.200601.1ac7c08";

  src = fetchFromGitHub {
    owner = "wez";
    repo = pname;
    rev = version;
    sha256 = "sha256-IhZe0vM41JhO8H79ZrRx4FRA4zfB6X0daC8QoE5MHmU=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ zlib ]
                ++ lib.optionals stdenv.isDarwin [ Cocoa ];

  installPhase = ''
    runHook preInstall
    install -D AtomicParsley $out/bin/AtomicParsley
    runHook postInstall
  '';

  meta = with lib; {
    description = "A CLI program for reading, parsing and setting metadata into MPEG-4 files";
    homepage = "https://github.com/wez/atomicparsley";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ pjones ];
  };
}
