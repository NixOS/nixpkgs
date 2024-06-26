{
  lib,
  stdenv,
  fetchFromGitHub,
  asciidoctor,
  gawk,
  gnused,
  runtimeShell,
}:

stdenv.mkDerivation rec {
  pname = "esh";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "jirutka";
    repo = "esh";
    rev = "v${version}";
    sha256 = "1ddaji5nplf1dyvgkrhqjy8m5djaycqcfhjv30yprj1avjymlj6w";
  };

  nativeBuildInputs = [ asciidoctor ];

  buildInputs = [
    gawk
    gnused
  ];

  makeFlags = [
    "prefix=$(out)"
    "DESTDIR="
  ];

  postPatch = ''
    patchShebangs .
    substituteInPlace esh \
        --replace '"/bin/sh"' '"${runtimeShell}"' \
        --replace '"awk"' '"${gawk}/bin/awk"' \
        --replace 'sed' '${gnused}/bin/sed'
    substituteInPlace tests/test-dump.exp \
        --replace '#!/bin/sh' '#!${runtimeShell}'
  '';

  doCheck = true;
  checkTarget = "test";

  meta = with lib; {
    description = "Simple templating engine based on shell";
    mainProgram = "esh";
    homepage = "https://github.com/jirutka/esh";
    license = licenses.mit;
    maintainers = with maintainers; [ mnacamura ];
    platforms = platforms.unix;
  };
}
