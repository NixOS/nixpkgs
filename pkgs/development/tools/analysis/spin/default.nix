{ stdenv, lib, fetchurl, makeWrapper, yacc, gcc
, withISpin ? true, tk, swarm, graphviz }:

let
  binPath = stdenv.lib.makeBinPath [ gcc ];
  ibinPath = stdenv.lib.makeBinPath [ gcc tk swarm graphviz tk ];

in stdenv.mkDerivation rec {
  name = "spin-${version}";
  version = "6.4.7";
  url-version = stdenv.lib.replaceChars ["."] [""] version;

  src = fetchurl {
    url = "http://spinroot.com/spin/Src/spin${url-version}.tar.gz";
    sha256 = "17m2xaag0jns8hsa4466zxq35ylg9fnzynzvjjmx4ympbiil6mqv";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ yacc ];

  sourceRoot = "Spin/Src${version}";

  installPhase = ''
    install -Dm755 spin $out/bin/spin
    wrapProgram $out/bin/spin \
      --prefix PATH : ${binPath}
  '' + lib.optionalString withISpin ''
    install -Dm755 ../iSpin/ispin.tcl $out/bin/ispin
    wrapProgram $out/bin/ispin \
      --prefix PATH ':' "$out/bin:${ibinPath}"
  '';

  meta = with stdenv.lib; {
    description = "Formal verification tool for distributed software systems";
    homepage = http://spinroot.com/;
    license = licenses.free;
    platforms = platforms.linux;
    maintainers = with maintainers; [ mornfall pSub ];
  };
}
