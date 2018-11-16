{ stdenv, fetchFromGitHub, asciidoctor, gawk, gnused }:

stdenv.mkDerivation rec {
  name = "esh-${version}";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "jirutka";
    repo = "esh";
    rev = "v${version}";
    sha256 = "1ddaji5nplf1dyvgkrhqjy8m5djaycqcfhjv30yprj1avjymlj6w";
  };

  nativeBuildInputs = [ asciidoctor ];

  buildInputs = [ gawk gnused ];

  makeFlags = [ "prefix=$(out)" "DESTDIR=" ];

  postPatch = ''
    patchShebangs .
    substituteInPlace esh \
        --replace '"/bin/sh"' '"${stdenv.shell}"' \
        --replace '"awk"' '"${gawk}/bin/awk"' \
        --replace 'sed' '${gnused}/bin/sed'
    substituteInPlace tests/test-dump.exp \
        --replace '#!/bin/sh' '#!${stdenv.shell}'
  '';

  doCheck = true;
  checkTarget = "test";

  meta = with stdenv.lib; {
    description = "Simple templating engine based on shell";
    homepage = https://github.com/jirutka/esh;
    license = licenses.mit;
    maintainers = with maintainers; [ mnacamura ];
    platforms = platforms.unix;
  };
}
