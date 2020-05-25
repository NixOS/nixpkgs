{ stdenv, fetchFromGitHub, pkgconfig
, libelf, zlib
}:

with builtins;

stdenv.mkDerivation rec {
  pname = "libbpf";
  version = "0.0.7";

  src = fetchFromGitHub {
    owner = "libbpf";
    repo = "libbpf";
    rev = "v${version}";
    sha256 = "1jcqhqvfbnbijm4jn949ibw1qywai9rwhyijf6lg8cvnyxkib2bs";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libelf zlib ];

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
