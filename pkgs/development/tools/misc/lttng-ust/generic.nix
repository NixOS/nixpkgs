{ version, sha256 }:

{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  liburcu,
  numactl,
  python3,
}:

# NOTE:
#   ./configure ...
#   [...]
#   LTTng-UST will be built with the following options:
#
#   Java support (JNI): Disabled
#   sdt.h integration:  Disabled
#   [...]
#
# Debian builds with std.h (systemtap).

stdenv.mkDerivation rec {
  pname = "lttng-ust";
  inherit version;

  src = fetchurl {
    url = "https://lttng.org/files/lttng-ust/${pname}-${version}.tar.bz2";
    inherit sha256;
  };

  outputs = [
    "bin"
    "out"
    "dev"
    "devdoc"
  ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    numactl
    python3
  ];

  preConfigure = ''
    patchShebangs .
  '';

  hardeningDisable = [ "trivialautovarinit" ];

  configureFlags = [ "--disable-examples" ];

  propagatedBuildInputs = [ liburcu ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "LTTng Userspace Tracer libraries";
    mainProgram = "lttng-gen-tp";
    homepage = "https://lttng.org/";
    license = with licenses; [
      lgpl21Only
      gpl2Only
      mit
    ];
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };

}
