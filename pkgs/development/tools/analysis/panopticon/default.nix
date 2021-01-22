{ stdenv, fetchFromGitHub, rustPlatform, qt5, git, cmake
, pkg-config, makeWrapper }:

rustPlatform.buildRustPackage rec {
  pname = "panopticon-unstable";
  version = "2017-12-02";

  src = fetchFromGitHub {
    owner = "das-labor";
    repo = pname;
    rev = "33ffec0d6d379d51b38d6ea00d040f54b1356ae4";
    sha256 = "1zv87nqhrzsxx0m891df4vagzssj3kblfv9yp7j96dw0vn9950qa";
  };

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ makeWrapper ];
  propagatedBuildInputs = with qt5; [
     qt5.qtbase
     qtdeclarative
     qtsvg
     qtquickcontrols2
     qtgraphicaleffects
     git
  ];

  cargoSha256 = "1hdsn011y9invfy7can8c02zwa7birj9y1rxhrj7wyv4gh3659i0";
  doCheck = false;

  postInstall = ''
    mkdir -p $out/share/panopticon $out/bin
    cp -R qml $out/share/panopticon
    mv $out/bin/panopticon $out/share/panopticon
    chmod +x $out/share/panopticon
    makeWrapper $out/share/panopticon/panopticon $out/bin/panopticon
     '';

  meta = with stdenv.lib; {
    description = "A libre cross-platform disassembler";
    longDescription = ''
      Panopticon is a cross platform disassembler for reverse
      engineering written in Rust. It can disassemble AMD64,
      x86, AVR and MOS 6502 instruction sets and open ELF files.
      Panopticon comes with Qt GUI for browsing and annotating
      control flow graphs.
    '';
    license = with licenses; [ gpl3 ];
    maintainers = with maintainers; [ leenaars ];
  };
}
