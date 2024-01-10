{ stdenv
, lib
, fetchFromGitHub
, substituteAll
, makeWrapper
, zsh
, coreutils
, cryptsetup
, e2fsprogs
, file
, gawk
, getent
, gettext
, gnugrep
, gnupg
, libargon2
, lsof
, pinentry
, util-linux
, nix-update-script
}:

stdenv.mkDerivation rec {
  pname = "tomb";
  version = "2.10";

  src = fetchFromGitHub {
    owner = "dyne";
    repo = "Tomb";
    rev = "refs/tags/v${version}";
    hash = "sha256-lLxQJX0P6b6lbXEcrq45EsX9iKiayZ9XkhqgMfpN3/w=";
  };

  buildInputs = [ zsh pinentry ];

  nativeBuildInputs = [ makeWrapper ];

  postPatch = ''
    # if not, it shows .tomb-wrapped when running
    substituteInPlace tomb \
      --replace 'TOMBEXEC=$0' 'TOMBEXEC=tomb'
  '';

  installPhase = ''
    install -Dm755 tomb $out/bin/tomb
    install -Dm644 doc/tomb.1 $out/share/man/man1/tomb.1

    wrapProgram $out/bin/tomb \
      --prefix PATH : $out/bin:${lib.makeBinPath [
          coreutils
          cryptsetup
          e2fsprogs
          file
          gawk
          getent
          gettext
          gnugrep
          gnupg
          libargon2
          lsof
          pinentry
          util-linux
        ]}
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "File encryption on GNU/Linux";
    homepage = "https://www.dyne.org/software/tomb/";
    changelog = "https://github.com/dyne/Tomb/blob/v${version}/ChangeLog.md";
    license = licenses.gpl3Only;
    mainProgram = "tomb";
    maintainers = with maintainers; [ peterhoeg anthonyroussel ];
    platforms = platforms.linux;
  };
}
