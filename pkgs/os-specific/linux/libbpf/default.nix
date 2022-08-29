{ fetchFromGitHub
, elfutils
, pkg-config
, stdenv
, zlib
, lib
, nixosTests
}:

stdenv.mkDerivation rec {
  pname = "libbpf";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "libbpf";
    repo = "libbpf";
    rev = "v${version}";
    sha256 = "sha256-daVS+TErmDU8ksThOvcepg1A61iD8N8GIkC40cmc9/8=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ elfutils zlib ];

  enableParallelBuilding = true;
  makeFlags = [ "PREFIX=$(out)" "-C src" ];

  passthru.tests = {
    bpf = nixosTests.bpf;
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
    description = "Upstream mirror of libbpf";
    homepage = "https://github.com/libbpf/libbpf";
    license = with licenses; [ lgpl21 /* or */ bsd2 ];
    maintainers = with maintainers; [ thoughtpolice vcunat saschagrunert martinetd ];
    platforms = platforms.linux;
  };
}
