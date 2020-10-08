{ stdenv
, fetchFromGitHub
, autoreconfHook
, fuse
, unrar
}:

stdenv.mkDerivation rec {
  pname = "rar2fs";
  version = "1.29.1";

  src = fetchFromGitHub {
    owner = "hasse69";
    repo = pname;
    rev = "v${version}";
    sha256 = "03m20bnlm70xamrxnswxs4fzc2lr2wr6f7jq6b3a8sdwq3pqbzzx";
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
