{ stdenv, fetchFromGitHub, coreutils, makeWrapper
, rsync, python3, pythonPackages }:

stdenv.mkDerivation rec {
  name = "mergerfs-tools-${version}";
  version = "20171221";

  src = fetchFromGitHub {
    owner = "trapexit";
    repo = "mergerfs-tools";
    rev = "9b4fe0097b5b51e1a7411a26eb344a24cc8ce1b4";
    sha256 = "0qrixh3j58gzkmc8r2sgzgy56gm8bmhakwlc2gjb0yrpa1213na1";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ python3 ];

  makeFlags = [
    "INSTALL=${coreutils}/bin/install"
    "PREFIX=$(out)"
  ];

  postInstall = with stdenv.lib; ''
    wrapProgram $out/bin/mergerfs.balance --prefix PATH : ${makeBinPath [ rsync ]}
    wrapProgram $out/bin/mergerfs.dup --prefix PATH : ${makeBinPath [ rsync ]}
    wrapProgram $out/bin/mergerfs.mktrash --prefix PATH : ${makeBinPath [ pythonPackages.xattr ]}
  '';

  meta = with stdenv.lib; {
    description = "Optional tools to help manage data in a mergerfs pool";
    homepage = https://github.com/trapexit/mergerfs-tools;
    license = licenses.isc;
    platforms = platforms.linux;
    maintainers = with maintainers; [ jfrankenau ];
  };
}
