{ stdenv, fetchFromGitHub, cmake, zlib, Cocoa }:

stdenv.mkDerivation rec {
  pname = "atomicparsley";
  version = "20200701.154658.b0d6223";

  src = fetchFromGitHub {
    owner = "wez";
    repo = pname;
    rev = version;
    sha256 = "sha256-EHO4WkxoAXUhuJKMNYmBbGfOgtO9uklzXtWS4QsV1c8=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ zlib ]
                ++ stdenv.lib.optionals stdenv.isDarwin [ Cocoa ];

  installPhase = ''
    runHook preInstall
    install -D AtomicParsley $out/bin/AtomicParsley
    runHook postInstall
  '';

  meta = with stdenv.lib; {
    description = "A CLI program for reading, parsing and setting metadata into MPEG-4 files";
    homepage = "https://github.com/wez/atomicparsley";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ pjones ];
  };
}
