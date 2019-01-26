{ lib, stdenv, fetchFromGitHub, perl }:

stdenv.mkDerivation {
  name = "perf-tools-20171219";

  src = fetchFromGitHub {
    owner = "brendangregg";
    repo = "perf-tools";
    rev = "98d42a2a1493d2d1c651a5c396e015d4f082eb20";
    sha256 = "09qnss9pd4kr6qadvp62m2g8sfrj86fksi1rr8m8w4314pzfb93c";
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

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    homepage = https://github.com/brendangregg/perf-tools;
    description = "Performance analysis tools based on Linux perf_events (aka perf) and ftrace";
    maintainers = [ maintainers.eelco ];
    license = licenses.gpl2;
  };
}
