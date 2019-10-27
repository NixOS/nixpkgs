{ stdenv, fetchurl, pkgconfig, udev, runtimeShellPackage, runtimeShell }:

stdenv.mkDerivation rec {
  # when updating this to >=7, check, see previous reverts:
  # nix-build -A nixos.tests.networking.scripted.macvlan.x86_64-linux nixos/release-combined.nix
  pname = "dhcpcd";
  version = "8.1.1";

  src = fetchurl {
    url = "mirror://roy/${pname}/${pname}-${version}.tar.xz";
    sha256 = "10pasmx3gi09amx9y2phwi3a2d5bwih44vlkdxmx7sqgw67k0pa8";
  };

  nativeBuildInputs = [ pkgconfig ];
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
  postInstall = stdenv.lib.optional (udev != null) "[ -e ${placeholder "out"}/lib/dhcpcd/dev/udev.so ]";

  meta = with stdenv.lib; {
    description = "A client for the Dynamic Host Configuration Protocol (DHCP)";
    homepage = https://roy.marples.name/projects/dhcpcd;
    platforms = platforms.linux;
    license = licenses.bsd2;
    maintainers = with maintainers; [ eelco fpletz ];
  };
}
