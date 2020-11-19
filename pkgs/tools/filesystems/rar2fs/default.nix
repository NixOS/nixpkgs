{ stdenv
, fetchFromGitHub
, autoreconfHook
, fuse
, unrar
}:

stdenv.mkDerivation rec {
  pname = "rar2fs";
  version = "1.29.2";

  src = fetchFromGitHub {
    owner = "hasse69";
    repo = pname;
    rev = "v${version}";
    sha256 = "0j7ai0gcbln2lyfc87xxmj0zpf3lnqa6fdm5rar3kdqhczb7s93y";
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
    homepage = "https://hasse69.github.io/rar2fs/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ kraem ];
    platforms = with platforms; linux ++ freebsd;
  };
}
