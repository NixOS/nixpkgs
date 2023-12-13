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
    mainProgram = "clipbuzz";
  };
})
