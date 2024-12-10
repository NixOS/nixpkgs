{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  zlib,
  Cocoa,
}:

stdenv.mkDerivation rec {
  pname = "atomicparsley";
  version = "20221229.172126.d813aa6";

  src = fetchFromGitHub {
    owner = "wez";
    repo = pname;
    rev = version;
    sha256 = "sha256-3otyOpDdiltZ0SR1hImfIDBi53PKuAvh93yq1X3Xkmo=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ zlib ] ++ lib.optionals stdenv.isDarwin [ Cocoa ];

  installPhase = ''
    runHook preInstall
    install -D AtomicParsley $out/bin/AtomicParsley
    runHook postInstall
  '';

  doCheck = true;

  postPatch = ''
    patchShebangs tests/test.sh
  '';

  # copying files so that we dont need to patch the test.sh
  checkPhase = ''
    (
    cp AtomicParsley ../tests
    cd ../tests
    mkdir tests
    mv *.mp4 tests
    ./test.sh
    )
  '';

  meta = with lib; {
    description = "A CLI program for reading, parsing and setting metadata into MPEG-4 files";
    homepage = "https://github.com/wez/atomicparsley";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ pjones ];
    mainProgram = "AtomicParsley";
  };
}
