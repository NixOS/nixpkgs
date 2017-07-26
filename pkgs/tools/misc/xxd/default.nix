{ stdenv, vim }:

stdenv.mkDerivation rec {
  name = "xxd-${version}";
  inherit (vim) version;
  phases = [ "installPhase" ];
  installPhase = ''
    mkdir -p $out/{bin,share/man/man1}
    install -m755 ${stdenv.lib.getBin vim}/bin/xxd $out/bin/xxd
    install -m644 ${stdenv.lib.getBin vim}/share/man/man1/xxd.1.gz $out/share/man/man1/xxd.1.gz
  '';
  meta = with stdenv.lib; {
    description = "Make a hexdump or do the reverse.";
    inherit (vim.meta) homepage license maintainers platforms;
  };
}
