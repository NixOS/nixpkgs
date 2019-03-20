{ stdenv, lib, fetchFromGitHub, makeWrapper
, gettext, zsh, pinentry, cryptsetup, gnupg, utillinux, e2fsprogs
}:

stdenv.mkDerivation rec {
  name = "tomb-${version}";
  version = "2.5";

  src = fetchFromGitHub {
    owner  = "dyne";
    repo   = "Tomb";
    rev    = "v${version}";
    sha256 = "1wk1aanzfln88min29p5av2j8gd8vj5afbs2gvarv7lvx1vi7kh1";
  };

  buildInputs = [ zsh pinentry ];

  nativeBuildInputs = [ makeWrapper ];

  postPatch = ''
    # if not, it shows .tomb-wrapped when running
    substituteInPlace tomb \
      --replace 'TOMBEXEC=$0' 'TOMBEXEC=tomb'
  '';

  doInstallCheck = true;
  installCheckPhase = "$out/bin/tomb -h 2>/dev/null";

  installPhase = ''
    install -Dm755 tomb       $out/bin/tomb
    install -Dm644 doc/tomb.1 $out/share/man/man1/tomb.1

    wrapProgram $out/bin/tomb \
      --prefix PATH : $out/bin:${lib.makeBinPath [ cryptsetup gettext gnupg pinentry utillinux e2fsprogs ]}
  '';

  meta = with stdenv.lib; {
    description = "File encryption on GNU/Linux";
    homepage    = https://www.dyne.org/software/tomb/;
    license     = licenses.gpl3;
    maintainers = with maintainers; [ peterhoeg ];
    platforms   = platforms.linux;
  };
}
