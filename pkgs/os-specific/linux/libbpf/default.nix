{ lib, stdenv, fetchFromGitHub
, pkg-config
, libelf, zlib
}:

stdenv.mkDerivation rec {
  pname = "libbpf";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner  = "libbpf";
    repo   = "libbpf";
    rev    = "v${version}";
    sha256 = "08mg5agd40qaz1hz5rqqhf0wgfna06f7l01z5v06y995xdmw2v9g";
  };

  patches = [
    # Adds a compatibility definition for BTF_KIND_FLOAT to allow files
    # that pull in <bpf/btf.h> to compile with pre-5.13 kernel headers
    ./libbpf-Add-BTF_KIND_FLOAT-compatibility-definition.patch
  ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libelf zlib ];

  sourceRoot = "source/src";
  enableParallelBuilding = true;
  makeFlags = [ "PREFIX=$(out)" ];

  # FIXME: Multi-output requires some fixes to the way the pkg-config file is
  # constructed (it gets put in $out instead of $dev for some reason, with
  # improper paths embedded). Don't enable it for now.

  # outputs = [ "out" "dev" ];

  meta = with lib; {
    description = "Upstream mirror of libbpf";
    homepage    = "https://github.com/libbpf/libbpf";
    license     = with licenses; [ lgpl21 /* or */ bsd2 ];
    maintainers = with maintainers; [ thoughtpolice vcunat ];
    platforms   = platforms.linux;
  };
}
