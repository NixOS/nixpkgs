{ stdenv, fetchFromGitHub, nim, termbox, pcre }:

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

  nim-src = fetchFromGitHub {
    owner = "nim-lang";
    repo = "Nim";
    rev = "v1.2.6";
    sha256 = "1rybp345szlw0b6rk88f6knlshy3ykrlhbvhgav7516zbs6xfgay";
  };

in stdenv.mkDerivation rec {
  pname = "nimlsp";
  version = "0.2.4";

  src = fetchFromGitHub {
    owner = "PMunch";
    repo = "nimlsp";
    rev = "v${version}";
    sha256 = "16j7avw2ki7bxc5nki4nazp737k2bd0ajpc5wrhn102c7rygmdrm";
  };

  nativeBuildInputs = [ nim ];
  buildInputs = [ termbox pcre ];

  buildPhase = ''
    export HOME=$TMPDIR;
    nim -p:${astpatternmatching}/src -p:${jsonschema}/src\
      c --threads:on -d:nimcore -d:nimsuggest -d:debugCommunication\
      -d:debugLogging -d:explicitSourcePath=${nim-src} -d:tempDir=/tmp src/nimlsp
  '';

  installPhase = ''
    install -Dt $out/bin src/nimlsp
  '';

  meta = with stdenv.lib; {
    description = "Nim Language Server Protocol - nimlsp implements the Language Server Protocol";
    homepage = "https://github.com/PMunch/nimlsp";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = [ maintainers.pmunch ];
  };
}

