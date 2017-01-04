{ stdenv, fetchurl, fetchFromGitHub
, file, libxslt, docbook_xml_dtd_412, docbook_xsl, xmlto
, w3m, which, gnugrep, gnused, coreutils
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
in

stdenv.mkDerivation rec {
  name = "xdg-utils-${version}";
  version = "1.1.1";

  src = fetchurl {
    url = "https://portland.freedesktop.org/download/${name}.tar.gz";
    sha256 = "09a1pk3ifsndc5qz2kcd1557i137gpgnv3d739pv22vfayi67pdh";
  };

  # just needed when built from git
  buildInputs = [ libxslt docbook_xml_dtd_412 docbook_xsl xmlto w3m ];

  postInstall = stdenv.lib.optionalString mimiSupport ''
    cp ${mimisrc}/xdg-open $out/bin/xdg-open
  ''
  + ''
    for tool in "${coreutils}/bin/cut" "${gnused}/bin/sed" \
      "${gnugrep}"/bin/{e,}grep "${file}/bin/file" \
      ${stdenv.lib.optionalString mimiSupport
        '' "${gawk}/bin/awk" "${coreutils}/bin/sort" ''} ;
    do
      sed "s# $(basename "$tool") # $tool #g" -i "$out"/bin/*
    done

    substituteInPlace $out/bin/xdg-open \
      --replace "/usr/bin/printf" "${coreutils}/bin/printf"

    substituteInPlace $out/bin/xdg-mime \
      --replace "/usr/bin/file" "${file}/bin/file"

    sed 's# which # type -P #g' -i "$out"/bin/*
  '';

  meta = with stdenv.lib; {
    homepage = http://portland.freedesktop.org/wiki/;
    description = "A set of command line tools that assist applications with a variety of desktop integration tasks";
    license = if mimiSupport then licenses.gpl2 else licenses.free;
    maintainers = [ maintainers.eelco ];
    platforms = platforms.all;
  };
}
