{ stdenv, fetchurl, makeWrapper, jre }:

stdenv.mkDerivation rec {
  name = "ktlint-${version}";
  version = "0.33.0";

  src = fetchurl {
    url = "https://github.com/shyiko/ktlint/releases/download/${version}/ktlint";
    sha256 = "11yh4d7ybmddw86n8ms259rwd3q0gx2qqir2x92dhywp6pb8g11b";
  };

  nativeBuildInputs = [ makeWrapper ];

  propagatedBuildInputs = [ jre ];

  unpackCmd = ''
    mkdir -p ${name}
    cp $curSrc ${name}/ktlint
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
