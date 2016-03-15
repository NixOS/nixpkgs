{ stdenv, fetchzip, fetchFromGitHub, file, libxslt, docbook_xml_dtd_412, docbook_xsl, xmlto
, w3m, which, gnugrep, gnused, coreutils
, mimiSupport ? false, gawk ? null }:

assert mimiSupport -> gawk != null;

let
  # A much better xdg-open
  mimisrc = fetchFromGitHub {
    owner = "march-linux";
    repo = "mimi";
    rev = "d85ea8256ed627e93b387cd42e4ab39bfab9504c";
    sha256 = "1h9mb3glfvc6pa2f9g07xgmf8lrwxiyjxvl906xlysy4klybxvhg";
  };
in

stdenv.mkDerivation rec {
  name = "xdg-utils-1.1.0-rc3p46";

  src = fetchzip {
    name = "${name}.tar.gz";
    url = "http://cgit.freedesktop.org/xdg/xdg-utils/snapshot/03577f987730.tar.gz";
    sha256 = "1fs0kxalmpqv6x0rv4xg65w8r26sk464xisrbwp4p6a033y5x34l";
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
