{ stdenv, fetchurl, makeWrapper, jre }:

stdenv.mkDerivation rec {
  pname = "ktlint";
  version = "0.34.2";

  src = fetchurl {
    url = "https://github.com/shyiko/ktlint/releases/download/${version}/ktlint";
    sha256 = "1v1s4y8ads2s8hjsjacxni1j0dbmnhilhnfs0xabr3aljqs15wb2";
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
    homepage = https://ktlint.github.io/;
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ tadfisher ];
  };
}
