{
  lib,
  stdenv,
  fetchFromGitHub,
  patsh,
  hostname,
}:

stdenv.mkDerivation rec {
  pname = "rmate";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "aurora";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-fmK6h9bqZ0zO3HWfZvPdYuZ6i/0HZ1CA3FUnkS+E9ns=";
  };

  nativeBuildInputs = [ patsh ];

  buildPhase = ''
    runHook preBuild

    substituteInPlace rmate \
      --replace-fail \
        'echo "hostname"' \
        'echo "${hostname}/bin/hostname"'
    patsh -f rmate -s ${builtins.storeDir}

    runHook preBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 rmate $out/bin/rmate

    runHook postInstall
  '';

  meta = with lib; {
    description = "Remote TextMate 2 implemented as shell script";
    longDescription = ''
      TextMate 2 has a nice feature where it is possible to edit
      files on a remote server using a helper script called 'rmate',
      which feeds the file back to the editor over a reverse tunnel.
      This is a rmate implementation in shell!
    '';
    homepage = "https://github.com/aurora/rmate";
    platforms = platforms.linux;
    license = licenses.gpl3;
    maintainers = with maintainers; [ pbsds ];
    mainProgram = "rmate";
  };
}
