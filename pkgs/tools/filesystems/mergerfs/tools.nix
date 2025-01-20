{
  lib,
  stdenv,
  fetchFromGitHub,
  coreutils,
  makeWrapper,
  rsync,
  python3,
}:

stdenv.mkDerivation rec {
  pname = "mergerfs-tools";
  version = "20230912";

  src = fetchFromGitHub {
    owner = "trapexit";
    repo = pname;
    rev = "80d6c9511da554009415d67e7c0ead1256c1fc41";
    hash = "sha256-9sn2ziIjes2squSGbjjXVch2zDFjQruWB4282p4jWcY=";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ python3 ];

  makeFlags = [
    "INSTALL=${coreutils}/bin/install"
    "PREFIX=${placeholder "out"}"
  ];

  postInstall = ''
    wrapProgram $out/bin/mergerfs.balance --prefix PATH : ${lib.makeBinPath [ rsync ]}
    wrapProgram $out/bin/mergerfs.dup --prefix PATH : ${lib.makeBinPath [ rsync ]}
    wrapProgram $out/bin/mergerfs.mktrash --prefix PATH : ${lib.makeBinPath [ python3.pkgs.xattr ]}
  '';

  meta = with lib; {
    description = "Optional tools to help manage data in a mergerfs pool";
    homepage = "https://github.com/trapexit/mergerfs-tools";
    license = licenses.isc;
    platforms = platforms.linux;
    maintainers = with maintainers; [ makefu ];
  };
}
