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
