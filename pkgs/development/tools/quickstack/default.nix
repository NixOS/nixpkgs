{ stdenv, lib, fetchFromGitHub, fetchpatch, cmake, pkg-config, libiberty, libelf, binutils-unwrapped, zlib }:
stdenv.mkDerivation {
  pname = "quickstack";
  version = "unstable-2021-01-26";

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [ libiberty libelf binutils-unwrapped zlib ];

  src = fetchFromGitHub {
    owner = "yoshinorim";
    repo = "quickstack";
    rev = "b853629a55fb7494b40c3bc52c743b428c73e39e";
    sha256 = "1jzl37rmipk8n9s5sl8xrp1bhxgc0607qcpn74px0dli2xm9cvb2";
  };

  patches = [
    (fetchpatch {
      # Submitted upstream: https://github.com/yoshinorim/quickstack/pull/14
      name = "find-deps-better.patch";
      url = "https://github.com/lheckemann/quickstack/commit/c6bc165e6ea3c03af8769f216f9f437d9021257b.patch";
      sha256 = "sha256-uCG75XAQQLcnye9S/MeIP77xhIVFOrF5MIni0941LVs=";
    })
  ];

  meta = {
    description = "Tool for low-overhead stack traces";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.lheckemann ];
  };
}
