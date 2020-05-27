{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "ttygif";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "icholy";
    repo = pname;
    rev = version;
    sha256 = "1w9c3h6hik2gglwsw8ww63piy66i4zqr3273wh5rc9r2awiwh643";
  };

  makeFlags = [ "CC:=$(CC)" "PREFIX=${placeholder "out"}" ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/icholy/ttygif";
    description = "Convert terminal recordings to animated gifs";
    platforms = platforms.unix;
    license = licenses.mit;
    maintainers = with maintainers; [ moaxcp ];
  };
}
