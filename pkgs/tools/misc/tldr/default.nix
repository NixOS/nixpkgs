{ stdenv, fetchFromGitHub, clang, curl, libzip, pkgconfig }:

stdenv.mkDerivation rec {
  name = "tldr-${version}";
  version = "1.1.0";

  src = fetchFromGitHub {
    sha256 = "0hxkrzp5njhy7c19v8i3svcb148f1jni7dlv36gc1nmcrz5izsiz";
    rev = "v${version}";
    repo = "tldr-cpp-client";
    owner = "tldr-pages";
  };

  buildInputs = [ curl clang libzip ];
  nativeBuildInputs = [ pkgconfig ];

  preConfigure = ''
    cd src
  '';

  installPhase = ''
    install -Dm755 {.,$out/bin}/tldr
  '';

  meta = with stdenv.lib; {
    description = "Simplified and community-driven man pages";
    longDescription = ''
      tldr pages gives common use cases for commands, so you don't need to hunt
      through a man page for the correct flags.
    '';
    homepage = http://tldr-pages.github.io;
    license = licenses.mit;
    maintainers = with maintainers; [ taeer nckx ];
    platforms = platforms.linux;
  };
}
