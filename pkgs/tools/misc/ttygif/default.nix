{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "ttygif";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "icholy";
    repo = pname;
    rev = version;
    sha256 = "18l26iacpfn4xqqv1ai6ncabn83mqv98c48gl265gfld66y7zbzn";
  };

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/icholy/ttygif";
    description = "Convert terminal recordings to animated gifs";
    platforms = platforms.linux;
    license = licenses.mit;
    maintainers = with maintainers; [ moaxcp ];
  };
}
