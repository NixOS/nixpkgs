{ stdenv, fetchurl, makeWrapper, jre }:

stdenv.mkDerivation rec {
  pname = "ktlint";
  version = "0.37.0";

  src = fetchurl {
    url = "https://github.com/shyiko/ktlint/releases/download/${version}/ktlint";
    sha256 = "1z2hvhcrz1rj9g8749x640axrf529wk361pckwb4ihn43c19ajpf";
  };

  nativeBuildInputs = [ makeWrapper ];

  propagatedBuildInputs = [ jre ];

  unpackCmd = ''
    mkdir -p ${pname}-${version}
    cp $curSrc ${pname}-${version}/ktlint
  '';

  installPhase = ''
    mkdir -p $out/bin
    mv ktlint $out/bin/ktlint
    chmod +x $out/bin/ktlint
  '';

  postFixup = ''
    wrapProgram $out/bin/ktlint --prefix PATH : "${jre}/bin"
  '';

  meta = with stdenv.lib; {
    description = "An anti-bikeshedding Kotlin linter with built-in formatter";
    homepage = "https://ktlint.github.io/";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ tadfisher ];
  };
}
