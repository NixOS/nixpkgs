{ stdenv, fetchFromGitHub, srcOnly, nim }:
let
  astpatternmatching = fetchFromGitHub {
    owner = "krux02";
    repo = "ast-pattern-matching";
    rev = "87f7d163421af5a4f5e5cb6da7b93278e6897e96";
    sha256 = "19mb5bb6riia8380p5dpc3q0vwgrj958dd6p7vw8vkvwiqrzg6zq";
  };

  jsonschema = fetchFromGitHub {
    owner = "PMunch";
    repo = "jsonschema";
    rev = "7b41c03e3e1a487d5a8f6b940ca8e764dc2cbabf";
    sha256 = "1js64jqd854yjladxvnylij4rsz7212k31ks541pqrdzm6hpblbz";
  };
in
stdenv.mkDerivation rec {
  pname = "nimlsp";
  version = "0.2.6";

  src = fetchFromGitHub {
    owner = "PMunch";
    repo = "nimlsp";
    rev = "v${version}";
    sha256 = "13kw3zjh0iqymwqxwhyj8jz6hgswwahf1rjd6iad7c6gcwrrg6yl";
  };

  nativeBuildInputs = [ nim ];

  buildPhase = ''
    export HOME=$TMPDIR
    nim -d:release -p:${astpatternmatching}/src -p:${jsonschema}/src \
      c --threads:on -d:nimcore -d:nimsuggest -d:debugCommunication \
      -d:debugLogging -d:explicitSourcePath=${srcOnly nim.unwrapped} -d:tempDir=/tmp src/nimlsp
  '';

  installPhase = ''
    install -Dt $out/bin src/nimlsp
  '';

  meta = with stdenv.lib; {
    description = "Language Server Protocol implementation for Nim";
    homepage = "https://github.com/PMunch/nimlsp";
    license = licenses.mit;
    platforms = nim.meta.platforms;
    maintainers = [ maintainers.marsam ];
  };
}
