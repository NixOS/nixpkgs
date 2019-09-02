{ stdenv, fetchFromGitHub, pkgconfig
, libelf
}:

with builtins;

stdenv.mkDerivation rec {
  pname = "libbpf";
  version = "0.0.3pre114_${substring 0 7 src.rev}";

  src = fetchFromGitHub {
    owner  = "libbpf";
    repo   = "libbpf";
    rev    = "672ae75b66fd8780a4214fe7b116c427e0809a52";
    sha256 = "1bdw1hc4m95irmybqlwax85b6m856g07p2slcw8b7jw3k4j9x075";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libelf ];

  sourceRoot = "source/src";
  enableParallelBuilding = true;
  makeFlags = [ "PREFIX=$(out)" ];

  patchPhase = ''
    substituteInPlace ../scripts/check-reallocarray.sh \
      --replace '/bin/rm' 'rm'
  '';

  # FIXME: Multi-output requires some fixes to the way the pkgconfig file is
  # constructed (it gets put in $out instead of $dev for some reason, with
  # improper paths embedded). Don't enable it for now.

  # outputs = [ "out" "dev" ];

  meta = with stdenv.lib; {
    description = "Upstream mirror of libbpf";
    homepage    = "https://github.com/libbpf/libbpf";
    license     = with licenses; [ lgpl21 /* or */ bsd2 ];
    maintainers = with maintainers; [ thoughtpolice ];
    platforms   = platforms.linux;
  };
}
