{ stdenv
, fetchFromGitHub
, autoreconfHook
, fuse
, unrar
}:

stdenv.mkDerivation rec {
  pname = "rar2fs";
  version = "1.28.0";

  src = fetchFromGitHub {
    owner = "hasse69";
    repo = pname;
    rev = "v${version}";
    sha256 = "0fmdqrs5yvn89ngc26vj5ggnalpwrdm8pdcfszw1wflh78hvd8kb";
  };

  postPatch = ''
    substituteInPlace get-version.sh \
      --replace "which echo" "echo"
  '';

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ fuse unrar ];

  configureFlags = [
    "--with-unrar=${unrar.dev}/include/unrar"
    "--disable-static-unrar"
  ];

  meta = with stdenv.lib; {
    description = "FUSE file system for reading RAR archives";
    homepage = https://hasse69.github.io/rar2fs/;
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ kraem ];
    platforms = with platforms; linux ++ freebsd;
  };
}
