{ lib, stdenv, fetchFromGitHub, cmake, zlib, Cocoa }:

stdenv.mkDerivation rec {
  pname = "atomicparsley";
  version = "20210124.204813.840499f";

  src = fetchFromGitHub {
    owner = "wez";
    repo = pname;
    rev = version;
    sha256 = "sha256-/bkfgIWlQobaiad2WD7DUUrTwfYurP7YAINaLTwBEcE=";
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
