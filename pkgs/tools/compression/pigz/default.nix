{ lib, stdenv, fetchFromGitHub, fetchpatch, zlib, util-linux }:

stdenv.mkDerivation rec {
  pname = "pigz";
  version = "2.7";

  src = fetchFromGitHub {
      owner = "madler";
      repo = pname;
      rev = "refs/tags/v${version}";
      sha256 = "sha256-RYp3vRwlI6S/lcib+3t7qLYFWv11GUnj1Cmxm9eaVro=";
  };

  patches = [
    # needed to build the pigzn test binary
    (fetchpatch {
      url = "https://github.com/madler/pigz/commit/67fd6e436f4f479aead529a719e24d6864cf1dfa.patch";
      sha256 = "sha256-FkzLYob/WIVIB7eh03cdzpLy6SzoHLqEMsWyHdMTjbU=";
    })
  ];

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
