{ lib
, stdenv
, fetchFromGitHub
, flex
, testers
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "opendetex";
  version = "2.8.9";

  src = fetchFromGitHub {
    owner = "pkubowicz";
    repo = "opendetex";
    rev = "v${finalAttrs.version}";
    hash = "sha256-8mwXsJImi8jESR87VA9NsUIvH52JJbbrjzpUdKPI+ls=";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace "install -c -m 775 -g staff" "install -c -m 775" \
      --replace "/usr/local" "$out"
  '';

  nativeBuildInputs = [
    flex
  ];

  preInstall = ''
    mkdir -p $out/share/man $out/bin
  '';

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
    command = "detex -v";
  };

  meta = with lib; {
    homepage = "https://github.com/pkubowicz/opendetex";
    description = "Improved version of Detex - tool for extracting plain text from TeX and LaTeX sources";
    license = licenses.ncsa;
    maintainers = with maintainers; [ fgaz ];
    platforms = platforms.all;
    mainProgram = "detex";
  };
})
