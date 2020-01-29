{ stdenv, lib, fetchurl, makeWrapper, perl
, unzip, gzip, file
# extractors which are added to unp’s PATH
, extraBackends ? []
}:

let
  runtime_bins =  [ file unzip gzip ] ++ extraBackends;

in stdenv.mkDerivation {
  pname = "unp";
  version = "2.0-pre7";
  buildInputs = [ perl makeWrapper ];

  src = fetchurl {
    # url = "http://http.debian.net/debian/pool/main/u/unp/unp_2.0~pre7+nmu1.tar.bz2";
    url = "mirror://debian/pool/main/u/unp/unp_2.0~pre7+nmu1.tar.bz2";
    sha256 = "09w2sy7ivmylxf8blf0ywxicvb4pbl0xhrlbb3i9x9d56ll6ybbw";
    name = "unp_2.0_pre7+nmu1.tar.bz2";
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

  meta = with stdenv.lib; {
    description = "Command line tool for unpacking archives easily";
    homepage = https://packages.qa.debian.org/u/unp.html;
    license = with licenses; [ gpl2 ];
    maintainers = [ maintainers.timor ];
    platforms = platforms.all;
  };
}
