{ stdenv, fetchurl, makeWrapper, jre }:

stdenv.mkDerivation rec {
  name = "ktlint-${version}";
  version = "0.30.0";

  src = fetchurl {
    url = "https://github.com/shyiko/ktlint/releases/download/${version}/ktlint";
    sha256 = "0l3h3q4qc7ij3sr9ij1mrhir18xic7qbzgb621fv16zgdk6rjghn";
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
