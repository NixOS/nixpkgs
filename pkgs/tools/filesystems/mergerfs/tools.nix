{ stdenv, fetchFromGitHub, coreutils, makeWrapper
, rsync, python3, pythonPackages }:

stdenv.mkDerivation rec {
  pname = "mergerfs-tools";
  version = "20190411";

  src = fetchFromGitHub {
    owner = "trapexit";
    repo = pname;
    rev = "6e41fc5848c7cc4408caea86f3991c8cc2ac85a1";
    sha256 = "0izswg6bya13scvb37l3gkl7mvi8q7l11p4hp4phdlcwh9jvdzcj";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ python3 ];

  makeFlags = [
    "INSTALL=${coreutils}/bin/install"
    "PREFIX=${placeholder "out"}"
  ];

  postInstall = with stdenv.lib; ''
    wrapProgram $out/bin/mergerfs.balance --prefix PATH : ${makeBinPath [ rsync ]}
    wrapProgram $out/bin/mergerfs.dup --prefix PATH : ${makeBinPath [ rsync ]}
    wrapProgram $out/bin/mergerfs.mktrash --prefix PATH : ${makeBinPath [ pythonPackages.xattr ]}
  '';

  meta = with stdenv.lib; {
    description = "Optional tools to help manage data in a mergerfs pool";
    homepage = "https://github.com/trapexit/mergerfs-tools";
    license = licenses.isc;
    platforms = platforms.linux;
    maintainers = with maintainers; [ jfrankenau ];
  };
}
