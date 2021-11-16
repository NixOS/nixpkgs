{ lib
, stdenv
, fetchurl
, pkg-config
, udev
, runtimeShellPackage
, runtimeShell
, nixosTests
}:

stdenv.mkDerivation rec {
  pname = "dhcpcd";
  version = "9.4.0";

  src = fetchurl {
    url = "mirror://roy/${pname}/${pname}-${version}.tar.xz";
    sha256 = "sha256-QaaSl/OAvxXuj5T3MVT4wrynFXoIfA1ayo3gALodRRM=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    udev
    runtimeShellPackage # So patchShebangs finds a bash suitable for the installed scripts
  ];

  prePatch = ''
    substituteInPlace hooks/dhcpcd-run-hooks.in --replace /bin/sh ${runtimeShell}
  '';

  preConfigure = "patchShebangs ./configure";

  configureFlags = [
    "--sysconfdir=/etc"
    "--localstatedir=/var"
  ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  # Hack to make installation succeed.  dhcpcd will still use /var/db
  # at runtime.
  installFlags = [ "DBDIR=$(TMPDIR)/db" "SYSCONFDIR=${placeholder "out"}/etc" ];

  # Check that the udev plugin got built.
  postInstall = lib.optionalString (udev != null) "[ -e ${placeholder "out"}/lib/dhcpcd/dev/udev.so ]";

  passthru.tests = { inherit (nixosTests.networking.scripted) macvlan dhcpSimple dhcpOneIf; };

  meta = with lib; {
    description = "A client for the Dynamic Host Configuration Protocol (DHCP)";
    homepage = "https://roy.marples.name/projects/dhcpcd";
    platforms = platforms.linux;
    license = licenses.bsd2;
    maintainers = with maintainers; [ eelco fpletz erictapen ];
  };
}
