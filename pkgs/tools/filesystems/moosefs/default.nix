{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
  fuse,
  pkg-config,
  libpcap,
  zlib,
  nixosTests,
}:

stdenv.mkDerivation rec {
  pname = "moosefs";
  version = "4.56.6";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-/ZvOwPE8SIwAbGITggzYwGuU1nAFIv0zF1IYu6FHGN8=";
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

  buildFlags = lib.optionals stdenv.hostPlatform.isDarwin [
    "CPPFLAGS=-UHAVE_STRUCT_STAT_ST_BIRTHTIME"
  ];

  # Fix the build on macOS with macFUSE installed
  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace configure --replace \
      "/usr/local/lib/pkgconfig" "/nonexistent"
  '';

  preBuild = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace config.h --replace \
      "#define HAVE_STRUCT_STAT_ST_BIRTHTIME 1" \
      "#undef HAVE_STRUCT_STAT_ST_BIRTHTIME"
  '';

  postInstall = ''
    substituteInPlace $out/sbin/mfscgiserv --replace "datapath=\"$out" "datapath=\""
  '';

  doCheck = true;

  passthru.tests = {
    inherit (nixosTests) moosefs;
  };

  meta = {
    homepage = "https://moosefs.com";
    description = "Open Source, Petabyte, Fault-Tolerant, Highly Performing, Scalable Network Distributed File System";
    platforms = lib.platforms.unix;
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [
      mfossen
      markuskowa
    ];
  };
}
