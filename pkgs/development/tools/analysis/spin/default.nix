{ stdenv, lib, fetchFromGitHub, makeWrapper, bison, gcc, tk, swarm, graphviz }:

let
  binPath = lib.makeBinPath [ gcc graphviz tk swarm ];
in

stdenv.mkDerivation rec {
  pname = "spin";
  version = "6.5.2";

  src = fetchFromGitHub {
    owner = "nimble-code";
    repo = "Spin";
    rev = "version-${version}";
    sha256 = "sha256-drvQXfDZCZRycBZt/VNngy8zs4XVJg+d1b4dQXVcyFU=";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ bison ];

  sourceRoot = "${src.name}/Src";

  preBuild = ''
    mkdir -p $out/bin
    mkdir -p $out/share/man/man1
  '';

  enableParallelBuilding = true;
  makeFlags = [ "DESTDIR=$(out)" ];

  postInstall = ''
    wrapProgram $out/bin/spin --prefix PATH : ${binPath}

    mkdir -p $out/share/spin
    cp $src/optional_gui/ispin.tcl $out/share/spin
    makeWrapper $out/share/spin/ispin.tcl $out/bin/ispin \
      --prefix PATH : $out/bin:${binPath}
  '';

  meta = with lib; {
    description = "Formal verification tool for distributed software systems";
    homepage = "https://spinroot.com/";
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ pSub siraben ];
  };
}
