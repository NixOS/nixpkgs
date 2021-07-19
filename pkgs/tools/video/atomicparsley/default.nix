{ lib, stdenv, fetchFromGitHub, cmake, zlib, Cocoa }:

stdenv.mkDerivation rec {
  pname = "atomicparsley";
  version = "20210715.151551.e7ad03a";

  src = fetchFromGitHub {
    owner = "wez";
    repo = pname;
    rev = version;
    sha256 = "sha256-77yWwfdEul4uLsUNX1dLwj8K0ilcuBaTVKMyXDvKVx4=";
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
