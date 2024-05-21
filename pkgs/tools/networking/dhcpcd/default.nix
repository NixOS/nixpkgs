{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, udev
, runtimeShellPackage
, runtimeShell
, nixosTests
, enablePrivSep ? true
}:

stdenv.mkDerivation rec {
  pname = "dhcpcd";
  version = "10.0.6";

  src = fetchFromGitHub {
    owner = "NetworkConfiguration";
    repo = "dhcpcd";
    rev = "v${version}";
    sha256 = "sha256-tNC5XCA8dShaTIff15mQz8v+YK9sZkRNLCX5qnlpxx4=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    udev
    runtimeShellPackage # So patchShebangs finds a bash suitable for the installed scripts
  ];

  postPatch = ''
    substituteInPlace hooks/dhcpcd-run-hooks.in --replace /bin/sh ${runtimeShell}
  '';

  configureFlags = [
    "--sysconfdir=/etc"
    "--localstatedir=/var"
  ]
  ++ (
    if ! enablePrivSep
    then [ "--disable-privsep" ]
    else [
      "--enable-privsep"
      # dhcpcd disables privsep if it can't find the default user,
      # so we explicitly specify a user.
      "--privsepuser=dhcpcd"
    ]
  );

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  # Hack to make installation succeed.  dhcpcd will still use /var/db
  # at runtime.
  installFlags = [ "DBDIR=$(TMPDIR)/db" "SYSCONFDIR=${placeholder "out"}/etc" ];

  # Check that the udev plugin got built.
  postInstall = lib.optionalString (udev != null) "[ -e ${placeholder "out"}/lib/dhcpcd/dev/udev.so ]";

  passthru = {
    inherit enablePrivSep;
    tests = { inherit (nixosTests.networking.scripted) macvlan dhcpSimple dhcpOneIf; };
  };

  meta = with lib; {
    description = "A client for the Dynamic Host Configuration Protocol (DHCP)";
    homepage = "https://roy.marples.name/projects/dhcpcd";
    platforms = platforms.linux;
    license = licenses.bsd2;
    maintainers = with maintainers; [ eelco ];
    mainProgram = "dhcpcd";
  };
}
