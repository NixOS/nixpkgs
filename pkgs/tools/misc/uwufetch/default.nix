{ lib, stdenv, fetchFromGitHub, fetchpatch, makeWrapper, viu }:

stdenv.mkDerivation rec {
  pname = "uwufetch";
  version = "1.7";

  src = fetchFromGitHub {
    owner = "TheDarkBug";
    repo = pname;
    rev = version;
    hash = "sha256-6yfRWFKdg7wM18hD2Bn095HzpnURhZJtx+SYx8SVBLA=";
  };

  patches = [
    # cannot find images in /usr
    ./fix-paths.patch
    # https://github.com/TheDarkBug/uwufetch/pull/150
    (fetchpatch {
      url = "https://github.com/lourkeur/uwufetch/commit/de561649145b57d8750843555e4ffbc1cbcb01f0.patch";
      sha256 = "sha256-KR81zxGlmthcadYBdsiVwxa5+lZUtqP7w0O4uFuputE=";
    })
  ];

  nativeBuildInputs = [ makeWrapper ];

  installFlags = [
    "PREFIX=${placeholder "out"}/bin"
    "LIBDIR=${placeholder "out"}/lib"
    "MANDIR=${placeholder "out"}/share/man/man1"
  ];

  postPatch = ''
    substituteAllInPlace uwufetch.c
  '';

  postFixup = ''
    wrapProgram $out/bin/uwufetch \
      --prefix PATH ":" ${lib.makeBinPath [ viu ]}
  '';

  meta = with lib; {
    description = "A meme system info tool for Linux";
    homepage = "https://github.com/TheDarkBug/uwufetch";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ lourkeur ];
  };
}
