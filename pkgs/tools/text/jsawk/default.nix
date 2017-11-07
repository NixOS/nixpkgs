{ stdenv, fetchFromGitHub, makeWrapper, spidermonkey }:

stdenv.mkDerivation rec {
  name = "jsawk-${version}";
  version = "1.5-pre";
  src = fetchFromGitHub {
    owner = "micha";
    repo = "jsawk";
    rev = "5a14c4af3c7b59807701b70a954ecefc6f77e978";
    sha256 = "0z3vdr3c8nvdrrxkjv9b4xg47mdb2hsknxpimw6shgwbigihapyr";
  };
  dontBuild = true;
  buildInputs = [ makeWrapper ];
  installPhase = ''
    mkdir -p $out/bin
    cp $src/jsawk $out/bin/
    wrapProgram $out/bin/jsawk \
      --prefix PATH : "${spidermonkey}/bin"
  '';

  meta = {
    description = "Jsawk is like awk, but for JSON";
    homepage = https://github.com/micha/jsawk;
    license = stdenv.lib.licenses.publicDomain;
    maintainers = with stdenv.lib.maintainers; [ puffnfresh ];
    platforms = stdenv.lib.platforms.unix;
  };
}
