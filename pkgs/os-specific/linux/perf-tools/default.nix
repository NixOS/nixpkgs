{ lib, stdenv, fetchFromGitHub, perl }:

stdenv.mkDerivation {
  name = "perf-tools-20150130";

  src = fetchFromGitHub {
    owner = "brendangregg";
    repo = "perf-tools";
    rev = "85414b01247666c9fefad25a1406c8078011c936";
    sha256 = "1g15nnndcmxd1k9radcvfpn223pp627vs9wh90yiy73v03g7b8cs";
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
