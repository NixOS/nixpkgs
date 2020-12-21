{ stdenv, lib, fetchFromGitHub, makeWrapper
, gettext, zsh, pinentry, cryptsetup, gnupg, util-linux, e2fsprogs, sudo
}:

stdenv.mkDerivation rec {
  pname = "tomb";
  version = "2.8.1";

  src = fetchFromGitHub {
    owner  = "dyne";
    repo   = "Tomb";
    rev    = "v${version}";
    sha256 = "03zj9az5626kjg96rkqr5sjydqwlrzhz0gq35r62sajv6mn2qm6s";
  };

  buildInputs = [ sudo zsh pinentry ];

  nativeBuildInputs = [ makeWrapper ];

  postPatch = ''
    # if not, it shows .tomb-wrapped when running
    substituteInPlace tomb \
      --replace 'TOMBEXEC=$0' 'TOMBEXEC=tomb'
  '';

  doInstallCheck = true;
  installCheckPhase = "$out/bin/tomb -h";

  installPhase = ''
    install -Dm755 tomb       $out/bin/tomb
    install -Dm644 doc/tomb.1 $out/share/man/man1/tomb.1

    wrapProgram $out/bin/tomb \
      --prefix PATH : $out/bin:${lib.makeBinPath [ cryptsetup gettext gnupg pinentry util-linux e2fsprogs ]}
  '';

  meta = with stdenv.lib; {
    description = "File encryption on GNU/Linux";
    homepage    = "https://www.dyne.org/software/tomb/";
    license     = licenses.gpl3;
    maintainers = with maintainers; [ peterhoeg ];
    platforms   = platforms.linux;
  };
}
