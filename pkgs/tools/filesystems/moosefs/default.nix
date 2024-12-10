{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
  fuse,
  pkg-config,
  libpcap,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "moosefs";
  version = "3.0.117";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-6zBMAi9ruPPlcnpdgqwl35QZ5u4MyFPUa70yvGTkHpo=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    fuse
    libpcap
    zlib
    python3
  ];

  strictDeps = true;

  buildFlags = lib.optionals stdenv.isDarwin [ "CPPFLAGS=-UHAVE_STRUCT_STAT_ST_BIRTHTIME" ];

  # Fix the build on macOS with macFUSE installed
  postPatch = lib.optionalString stdenv.isDarwin ''
    substituteInPlace configure --replace \
      "/usr/local/lib/pkgconfig" "/nonexistent"
  '';

  preBuild = lib.optionalString stdenv.isDarwin ''
    substituteInPlace config.h --replace \
      "#define HAVE_STRUCT_STAT_ST_BIRTHTIME 1" \
      "#undef HAVE_STRUCT_STAT_ST_BIRTHTIME"
  '';

  postInstall = ''
    substituteInPlace $out/sbin/mfscgiserv --replace "datapath=\"$out" "datapath=\""
  '';

  doCheck = true;

  meta = with lib; {
    homepage = "https://moosefs.com";
    description = "Open Source, Petabyte, Fault-Tolerant, Highly Performing, Scalable Network Distributed File System";
    platforms = platforms.unix;
    license = licenses.gpl2Only;
    maintainers = [ maintainers.mfossen ];
  };
}
