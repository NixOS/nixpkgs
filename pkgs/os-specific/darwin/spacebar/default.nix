{ stdenv, fetchFromGitHub, Carbon, Cocoa, ScriptingBridge }:

stdenv.mkDerivation rec {
  pname = "spacebar";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "cmacrae";
    repo = pname;
    rev = "v${version}";
    sha256 = "1x0wzm380nv81j26jqqg4y4dwanydnpdsca41ndw6xyj9zlv73f7";
  };

  buildInputs = [ Carbon Cocoa ScriptingBridge ];

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share/man/man1/
    cp ./bin/spacebar $out/bin/spacebar
    cp ./doc/spacebar.1 $out/share/man/man1/spacebar.1
  '';

  meta = with stdenv.lib; {
    description = "A minimal status bar for macOS";
    homepage = "https://github.com/cmacrae/spacebar";
    platforms = platforms.darwin;
    maintainers = [ maintainers.cmacrae ];
    license = licenses.mit;
  };
}
