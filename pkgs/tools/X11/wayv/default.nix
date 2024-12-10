{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  libX11,
}:
stdenv.mkDerivation rec {
  pname = "wayv";
  version = "0.3";

  src = fetchFromGitHub {
    owner = "mikemb";
    repo = pname;
    rev = "b716877603250f690f08b593bf30fd5e8a93a872";
    sha256 = "046dvaq6na1fyxz5nrjg13aaz6ific9wbygck0dknqqfmmjrsv3b";
  };

  patches = [
    # Pull patch pending upstream inclusion for -fno-common toolchain support:
    #   https://github.com/mikemb/wayV/pull/1
    (fetchpatch {
      name = "fno-common.patch";
      url = "https://github.com/mikemb/wayV/commit/b927793e2a2c92ff1f97b9df9e58c26e73e72012.patch";
      sha256 = "19i10966b0n710dic64p5ajsllkjnz16bp0crxfy9vv08hj1xygi";
    })
  ];

  buildInputs = [ libX11 ];

  postInstall = ''
    make -C doc install
    mkdir -p "$out"/share/doc/wayv
    cp [A-Z][A-Z]* "$out"/share/doc/wayv
    cp doc/[A-Z][A-Z]* "$out"/share/doc/wayv
    cp doc/*.txt "$out"/share/doc/wayv
    cp doc/*.jpg "$out"/share/doc/wayv
  '';

  meta = {
    description = "A gesture control for X11";
    license = lib.licenses.gpl2Plus;
    maintainers = [ lib.maintainers.raskin ];
    platforms = lib.platforms.linux;
    homepage = "https://github.com/mikemb/wayV";
    mainProgram = "wayv";
  };
}
