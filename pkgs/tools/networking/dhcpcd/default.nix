{ stdenv, fetchurl, fetchpatch, pkgconfig, udev, runtimeShellPackage,
runtimeShell }:

stdenv.mkDerivation rec {
  # when updating this to >=7, check, see previous reverts:
  # nix-build -A nixos.tests.networking.scripted.macvlan.x86_64-linux nixos/release-combined.nix
  pname = "dhcpcd";
  version = "8.1.4";

  src = fetchurl {
    url = "mirror://roy/${pname}/${pname}-${version}.tar.xz";
    sha256 = "0gf1qif25wy5lffzw39pi4sshmpxz1f4a1m9sglj7am1gaix3817";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    udev
    runtimeShellPackage # So patchShebangs finds a bash suitable for the installed scripts
  ];

  prePatch = ''
    substituteInPlace hooks/dhcpcd-run-hooks.in --replace /bin/sh ${runtimeShell}
  '';

  patches = [
    (fetchpatch {
      name = "?id=114870290a8d3d696bc4049c32eef3eed03d6070";
      url = "https://roy.marples.name/git/dhcpcd/commitdiff_plain/114870290a8d3d696bc4049c32eef3eed03d6070";
      sha256 = "0kzpwjh2gzvl5lvlnw6lis610p67nassk3apns68ga2pyxlky8qb";
    })
  ];

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
    homepage = "https://roy.marples.name/projects/dhcpcd";
    platforms = platforms.linux;
    license = licenses.bsd2;
    maintainers = with maintainers; [ eelco fpletz ];
  };
}
