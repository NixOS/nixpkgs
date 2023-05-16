<<<<<<< HEAD
{ lib
, stdenv
, fetchzip
, libX11
, libXfixes
, zig_0_11
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "clipbuzz";
  version = "2.0.1";

  src = fetchzip {
    url = "https://trong.loang.net/~cnx/clipbuzz/snapshot/clipbuzz-${finalAttrs.version}.tar.gz";
    hash = "sha256-2//IwthAjGyVSZaXjgpM1pUJGYWZVkrJ6JyrVbzOtr8=";
  };

  nativeBuildInputs = [ zig_0_11.hook ];

  buildInputs = [
    libX11
    libXfixes
  ];

  meta =  {
    description = "Buzz on new X11 clipboard events";
    homepage = "https://trong.loang.net/~cnx/clipbuzz";
    license = lib.licenses.unlicense;
    maintainers = [ lib.maintainers.McSinyx ];
  };
})
=======
{ stdenv, lib, fetchFromSourcehut, zig, libX11, libXfixes }:

stdenv.mkDerivation rec {
  pname = "clipbuzz";
  version = "2.0.0";

  src = fetchFromSourcehut {
    owner = "~cnx";
    repo = pname;
    rev = version;
    sha256 = "1qn98bwp7v7blw4v0g4pckgxrky5ggvq9m0kck2kqw8jg9jc15jp";
  };

  nativeBuildInputs = [ zig ];
  buildInputs = [ libX11 libXfixes ];

  preBuild = ''
    export HOME=$TMPDIR
  '';

  installPhase = ''
    zig build -Drelease-safe -Dcpu=baseline --prefix $out install
  '';

  meta = with lib; {
    description = "Buzz on new X11 clipboard events";
    homepage = "https://git.sr.ht/~cnx/clipbuzz";
    license = licenses.unlicense;
    maintainers = [ maintainers.McSinyx ];
  };
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
