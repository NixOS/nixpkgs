{ stdenv, fetchFromGitHub, pkgconfig
, libelf, zlib
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

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libelf zlib ];

  sourceRoot = "source/src";
  enableParallelBuilding = true;
  makeFlags = [ "PREFIX=$(out)" ];

  patchPhase = ''
    substituteInPlace ../scripts/check-reallocarray.sh \
      --replace '/bin/rm' 'rm'
    # Without patching this the config-test program will be refused by our CC wrapper.
    chmod +w ../scripts
    sed -e '2a NIX_ENFORCE_PURITY=0' -i ../scripts/check-reallocarray.sh
  '';

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
