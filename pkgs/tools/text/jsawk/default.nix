{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  spidermonkey_102,
}:

stdenv.mkDerivation {
  pname = "jsawk";
  version = "1.5-pre";
  src = fetchFromGitHub {
    owner = "micha";
    repo = "jsawk";
    rev = "5a14c4af3c7b59807701b70a954ecefc6f77e978";
    sha256 = "0z3vdr3c8nvdrrxkjv9b4xg47mdb2hsknxpimw6shgwbigihapyr";
  };
  dontBuild = true;
  nativeBuildInputs = [ makeWrapper ];
  installPhase = ''
    mkdir -p $out/bin
    cp $src/jsawk $out/bin/
    wrapProgram $out/bin/jsawk \
      --prefix PATH : "${spidermonkey_102}/bin"
  '';

  meta = {
    description = "Like awk, but for JSON";
    mainProgram = "jsawk";
    homepage = "https://github.com/micha/jsawk";
    license = lib.licenses.publicDomain;
    maintainers = with lib.maintainers; [ puffnfresh ];
    platforms = lib.platforms.unix;
  };
}
