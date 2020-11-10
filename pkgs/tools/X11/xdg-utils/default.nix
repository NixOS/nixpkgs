{ stdenv, fetchurl, fetchFromGitHub
, file, libxslt, docbook_xml_dtd_412, docbook_xsl, xmlto
, w3m, gnugrep, gnused, coreutils, xset, perlPackages
, mimiSupport ? false, gawk ? null }:

assert mimiSupport -> gawk != null;

let
  # A much better xdg-open
  mimisrc = fetchFromGitHub {
    owner = "march-linux";
    repo = "mimi";
    rev = "8e0070f17bcd3612ee83cb84e663e7c7fabcca3d";
    sha256 = "15gw2nyrqmdsdin8gzxihpn77grhk9l97jp7s7pr7sl4n9ya2rpj";
  };

  perlPath = with perlPackages; makePerlPath [
    NetDBus XMLTwig XMLParser X11Protocol
  ];

in

stdenv.mkDerivation rec {
  pname = "xdg-utils";
  version = "1.1.3";

  src = fetchurl {
    url = "https://portland.freedesktop.org/download/${pname}-${version}.tar.gz";
    sha256 = "1nai806smz3zcb2l5iny4x7li0fak0rzmjg6vlyhdqm8z25b166p";
  };

  # just needed when built from git
  buildInputs = [ libxslt docbook_xml_dtd_412 docbook_xsl xmlto w3m ];

  postInstall = stdenv.lib.optionalString mimiSupport ''
    cp ${mimisrc}/xdg-open $out/bin/xdg-open
  '' + ''
    sed  '2s#.#\
    cut()   { ${coreutils}/bin/cut  "$@"; }\
    sed()   { ${gnused}/bin/sed     "$@"; }\
    grep()  { ${gnugrep}/bin/grep   "$@"; }\
    egrep() { ${gnugrep}/bin/egrep  "$@"; }\
    file()  { ${file}/bin/file      "$@"; }\
    awk()   { ${gawk}/bin/awk       "$@"; }\
    sort()  { ${coreutils}/bin/sort "$@"; }\
    xset()  { ${xset}/bin/xset      "$@"; }\
    perl()  { PERL5LIB=${perlPath} ${perlPackages.perl}/bin/perl "$@"; }\
    mimetype() { ${perlPackages.FileMimeInfo}/bin/mimetype "$@"; }\
    PATH=$PATH:'"$out"'/bin\
    &#' -i "$out"/bin/*

    substituteInPlace $out/bin/xdg-open \
      --replace "/usr/bin/printf" "${coreutils}/bin/printf"

    substituteInPlace $out/bin/xdg-mime \
      --replace "/usr/bin/file" "${file}/bin/file"

    substituteInPlace $out/bin/xdg-email \
      --replace "/bin/echo" "${coreutils}/bin/echo"

    sed 's# which # type -P #g' -i "$out"/bin/*
  '';

  meta = with stdenv.lib; {
    homepage = "https://www.freedesktop.org/wiki/Software/xdg-utils/";
    description = "A set of command line tools that assist applications with a variety of desktop integration tasks";
    license = if mimiSupport then licenses.gpl2 else licenses.free;
    maintainers = [ maintainers.eelco ];
    platforms = platforms.all;
  };
}
