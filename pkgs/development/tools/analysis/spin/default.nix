{ stdenv, lib, requireFile, makeWrapper, yacc, gcc
, withISpin ? true, tk, swarm, graphviz }:

let
  binPath = stdenv.lib.makeBinPath [ gcc ];
  ibinPath = stdenv.lib.makeBinPath [ gcc tk swarm graphviz tk ];

in stdenv.mkDerivation rec {
  name = "spin-${version}";
  version = "6.4.8";
  url-version = stdenv.lib.replaceChars ["."] [""] version;

  src = requireFile {
    name = "spin${url-version}.tar.gz";
    sha256 = "1rpazi5fj772121cn7r85fxypmaiv0x6x2l82b5y1xqzyf0fi4ph";
    message = ''
      reCAPTCHA is preventing us to download the file for you.
      Please download it at http://spinroot.com/spin/Src/index.html
      and add it to the nix-store using nix-prefetch-url.
    '';
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ yacc ];

  sourceRoot = "Spin/Src${version}";

  unpackPhase = ''
    # The archive is compressed twice
    gunzip -c $src > spin.tar.gz
    tar -xzf spin.tar.gz
  '';

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
    maintainers = with maintainers; [ pSub ];
  };
}
