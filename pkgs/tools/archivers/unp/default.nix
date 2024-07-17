{
  stdenv,
  lib,
  fetchurl,
  makeWrapper,
  perl,
  unzip,
  gzip,
  file,
  # extractors which are added to unp’s PATH
  extraBackends ? [ ],
}:

let
  runtime_bins = [
    file
    unzip
    gzip
  ] ++ extraBackends;

in
stdenv.mkDerivation {
  pname = "unp";
  version = "2.0-pre9";
  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ perl ];

  src = fetchurl {
    url = "mirror://debian/pool/main/u/unp/unp_2.0~pre9.tar.xz";
    sha256 = "1lp5vi9x1qi3b21nzv0yqqacj6p74qkl5zryzwq30rjkyvahjya1";
    name = "unp_2.0_pre9.tar.xz";
  };

  dontConfigure = true;
  buildPhase = "true";
  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share/man/man1
    install ./unp $out/bin/unp
    install ./ucat $out/bin/ucat
    cp debian/unp.1 $out/share/man/man1

    wrapProgram $out/bin/unp \
      --prefix PATH : ${lib.makeBinPath runtime_bins}
    wrapProgram $out/bin/ucat \
      --prefix PATH : ${lib.makeBinPath runtime_bins}
  '';

  meta = with lib; {
    description = "Command line tool for unpacking archives easily";
    homepage = "https://packages.qa.debian.org/u/unp.html";
    license = with licenses; [ gpl2Only ];
    maintainers = [ maintainers.timor ];
    platforms = platforms.all;
  };
}
