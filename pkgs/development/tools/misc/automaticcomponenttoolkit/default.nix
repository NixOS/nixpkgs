{ stdenv, lib, fetchFromGitHub, go }:

stdenv.mkDerivation rec {
  pname = "AutomaticComponentToolkit";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "Autodesk";
    repo = pname;
    rev = "v${version}";
    sha256 = "1r0sbw82cf9dbcj3vgnbd4sc1lklzvijic2z5wgkvs21azcm0yzh";
  };

  nativeBuildInputs = [ go ];

  buildPhase = ''
    cd Source
    export HOME=/tmp
    go build -o act *.go
  '';

  installPhase = ''
    install -Dm0755 act $out/bin/act
  '';

  meta = with lib; {
    description = "Toolkit to automatically generate software components: abstract API, implementation stubs and language bindings";
    mainProgram = "act";
    homepage = "https://github.com/Autodesk/AutomaticComponentToolkit";
    license = licenses.bsd2;
    maintainers = with maintainers; [ gebner ];
    platforms = platforms.all;
  };
}
