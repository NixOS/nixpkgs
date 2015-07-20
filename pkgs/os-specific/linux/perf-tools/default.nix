{ lib, stdenv, fetchFromGitHub, perl }:

stdenv.mkDerivation {
  name = "perf-tools-20150704";

  src = fetchFromGitHub {
    owner = "brendangregg";
    repo = "perf-tools";
    rev = "30ff4758915a98fd43020c1b45a63341208fd8b9";
    sha256 = "0x59xm96jmpfgik6f9d6q6v85dip3kvi4ncijpghhg59ayyd5i6a";
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
