{ lib, stdenv, fetchFromGitHub, zlib, util-linux }:

stdenv.mkDerivation rec {
  pname = "pigz";
  version = "2.6";

  src = fetchFromGitHub {
      owner = "madler";
      repo = "${pname}";
      rev = "refs/tags/v${version}";
      sha256 = "146qkmzi199xwmmf6bllanqfyl702fm1rnad8cd5r5yyrp5ks115";
  };

  enableParallelBuilding = true;

  buildInputs = [ zlib ] ++ lib.optional stdenv.isLinux util-linux;

  makeFlags = [ "CC=${stdenv.cc}/bin/${stdenv.cc.targetPrefix}cc" ];

  doCheck = stdenv.isLinux;
  checkTarget = "tests";
  installPhase = ''
    install -Dm755 pigz "$out/bin/pigz"
    ln -s pigz "$out/bin/unpigz"
    install -Dm755 pigz.1 "$out/share/man/man1/pigz.1"
    ln -s pigz.1 "$out/share/man/man1/unpigz.1"
    install -Dm755 pigz.pdf "$out/share/doc/pigz/pigz.pdf"
  '';

  meta = with lib; {
    homepage = "https://www.zlib.net/pigz/";
    description = "A parallel implementation of gzip for multi-core machines";
    maintainers = with maintainers; [ ];
    license = licenses.zlib;
    platforms = platforms.unix;
  };
}
