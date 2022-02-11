{ bzip2, fetchFromGitHub, gzip, gnutar, lib, stdenv, unzip, xz }:

stdenv.mkDerivation rec {
  pname = "xtrt";
  version = "unstable-2021-02-17";

  src = fetchFromGitHub {
    owner = "figsoda";
    repo = pname;
    rev = "61884fb7c48c7e1e2194afd82b85f415a6dc7c20";
    sha256 = "073l4q6mx5if791p5a6w8m8bz2aypmjmycaijq4spql8bh6h12vf";
  };

  postPatch = ''
    substituteInPlace xtrt \
      --replace "bzip2 " "${bzip2}/bin/bzip2 " \
      --replace "gzip " "${gzip}/bin/gzip " \
      --replace "tar " "${gnutar}/bin/tar " \
      --replace "unzip " "${unzip}/bin/unzip " \
      --replace "xz " "${xz}/bin/xz "
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp xtrt $out/bin
    runHook postInstall
  '';

  meta = with lib; {
    description = "Tiny script to extract archives by their extensions";
    homepage = "https://github.com/figsoda/xtrt";
    license = licenses.unlicense;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "xtrt";
  };
}
