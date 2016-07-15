{ lib, stdenv, fetchFromGitHub, perl }:

stdenv.mkDerivation {
  name = "perf-tools-20160418";

  src = fetchFromGitHub {
    owner = "brendangregg";
    repo = "perf-tools";
    rev = "5a511f5f775cfbc0569e6039435361cecd22dd86";
    sha256 = "1ab735idi0h62yvhzd7822jj3555vygixv4xjrfrdvi8d2hhz6qn";
  };

  buildInputs = [ perl ];

  patchPhase =
    ''
      for i in execsnoop iolatency iosnoop kernel/funcslower killsnoop opensnoop; do
        substituteInPlace $i \
          --replace /usr/bin/gawk "$(type -p gawk)" \
          --replace /usr/bin/mawk /no-such-path \
          --replace /usr/bin/getconf "$(type -p getconf)" \
          --replace awk=awk "awk=$(type -p gawk)"
      done

      rm -rf examples deprecated
    '';

  installPhase =
    ''
      d=$out/libexec/perf-tools
      mkdir -p $d $out/share
      cp -prvd . $d/
      ln -s $d/bin $out/bin
      mv $d/man $out/share/
    '';

  meta = {
    platforms = lib.platforms.linux;
    homepage = https://github.com/brendangregg/perf-tools;
    description = "Performance analysis tools based on Linux perf_events (aka perf) and ftrace";
    maintainers = [ lib.maintainers.eelco ];
  };
}
