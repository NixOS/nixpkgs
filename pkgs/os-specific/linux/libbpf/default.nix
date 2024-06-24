{ fetchFromGitHub
, elfutils
, pkg-config
, stdenv
, zlib
, lib

# for passthru.tests
, knot-dns
, nixosTests
, systemd
, tracee
}:

stdenv.mkDerivation rec {
  pname = "libbpf";
  version = "1.4.3";

  src = fetchFromGitHub {
    owner = "libbpf";
    repo = "libbpf";
    rev = "v${version}";
    sha256 = "sha256-lcIOgghlBKrDCBDdO0hryjt8KADQd6aroQMun3ein2o=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ elfutils zlib ];

  enableParallelBuilding = true;
  makeFlags = [ "PREFIX=$(out)" "-C src" ];

  passthru.tests = {
    inherit knot-dns tracee;
    bpf = nixosTests.bpf;
    systemd = systemd.override { withLibBPF = true; };
  };

  postInstall = ''
    # install linux's libbpf-compatible linux/btf.h
    install -Dm444 include/uapi/linux/*.h -t $out/include/linux
  '';

  # FIXME: Multi-output requires some fixes to the way the pkg-config file is
  # constructed (it gets put in $out instead of $dev for some reason, with
  # improper paths embedded). Don't enable it for now.

  # outputs = [ "out" "dev" ];

  meta = with lib; {
    description = "Library for loading eBPF programs and reading and manipulating eBPF objects from user-space";
    homepage = "https://github.com/libbpf/libbpf";
    license = with licenses; [ lgpl21 /* or */ bsd2 ];
    maintainers = with maintainers; [ thoughtpolice vcunat saschagrunert martinetd ];
    platforms = platforms.linux;
  };
}
