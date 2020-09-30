{ stdenv, fetchFromGitHub, pkgconfig
, libelf, zlib
, fetchpatch
}:

with builtins;

stdenv.mkDerivation rec {
  pname = "libbpf";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner  = "libbpf";
    repo   = "libbpf";
    rev    = "v${version}";
    sha256 = "0ilnnm4q22f8fagwp8kb37licy4ks861i2iqh2djsypqhnxvx3fv";
  };

  patches = [
    (fetchpatch { # included upstream for > 0.1.0
      name = "link-zlib.patch";
      url = "https://github.com/libbpf/libbpf/commit/8b14cb43ff837.diff";
      sha256 = "17mvjrs7s727drz013a8qlyj0345ldi2kph6pazcmxv6kl1qrz2z";
    })
  ];
  patchFlags = "-p2";
  # https://github.com/libbpf/libbpf/pull/201#issuecomment-689174740
  postPatch = ''
    substituteInPlace ../scripts/check-reallocarray.sh \
      --replace 'mktemp /tmp/' 'mktemp ' \
      --replace '/bin/rm' 'rm'
  '';

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libelf zlib ];

  sourceRoot = "source/src";
  enableParallelBuilding = true;
  makeFlags = [ "PREFIX=$(out)" ];

  # FIXME: Multi-output requires some fixes to the way the pkgconfig file is
  # constructed (it gets put in $out instead of $dev for some reason, with
  # improper paths embedded). Don't enable it for now.

  # outputs = [ "out" "dev" ];

  meta = with stdenv.lib; {
    description = "Upstream mirror of libbpf";
    homepage    = "https://github.com/libbpf/libbpf";
    license     = with licenses; [ lgpl21 /* or */ bsd2 ];
    maintainers = with maintainers; [ thoughtpolice vcunat ];
    platforms   = platforms.linux;
  };
}
