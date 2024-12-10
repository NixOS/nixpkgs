{
  lib,
  stdenv,
  fetchFromGitHub,
  nixosTests,
  file,
  libmnl,
  libnftnl,
  libnl,
  net-snmp,
  openssl,
  pkg-config,
  autoreconfHook,
  withNetSnmp ? stdenv.buildPlatform.canExecute stdenv.hostPlatform,
}:

stdenv.mkDerivation rec {
  pname = "keepalived";
  version = "2.2.8";

  src = fetchFromGitHub {
    owner = "acassen";
    repo = "keepalived";
    rev = "v${version}";
    sha256 = "sha256-QkebGQCYE4ccUvcxKG3qQ4wqC+RzxGHim8kgHQbIr5Q=";
  };

  buildInputs =
    [
      file
      libmnl
      libnftnl
      libnl
      openssl
    ]
    ++ lib.optionals withNetSnmp [
      net-snmp
    ];

  enableParallelBuilding = true;

  passthru.tests.keepalived = nixosTests.keepalived;

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
  ];

  configureFlags =
    [
      "--enable-sha1"
    ]
    ++ lib.optionals withNetSnmp [
      "--enable-snmp"
    ];

  meta = with lib; {
    homepage = "https://keepalived.org";
    description = "Routing software written in C";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.raitobezarius ];
  };
}
