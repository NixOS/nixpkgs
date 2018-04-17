{ stdenv, fetchurl, pkgconfig, udev, runtimeShellPackage }:

stdenv.mkDerivation rec {
  # when updating this to >=7, check, see previous reverts:
  # nix-build -A nixos.tests.networking.scripted.macvlan.x86_64-linux nixos/release-combined.nix
  name = "dhcpcd-6.11.5";

  src = fetchurl {
    url = "mirror://roy/dhcpcd/${name}.tar.xz";
    sha256 = "17nnhxmbdcc7k2mh6sgvxisqcqbic5540xbig363ds97gvf795kg";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ udev ];

  preConfigure = "patchShebangs ./configure";

  configureFlags = [
    "--sysconfdir=/etc"
    "--localstatedir=/var"
  ];

  makeFlags = "PREFIX=\${out}";

  # Hack to make installation succeed.  dhcpcd will still use /var/db
  # at runtime.
  installFlags = "DBDIR=\${TMPDIR}/db SYSCONFDIR=$(out)/etc";

  # Check that the udev plugin got built.
  postInstall = stdenv.lib.optional (udev != null) "[ -e $out/lib/dhcpcd/dev/udev.so ]";

  # TODO shlevy remove once patchShebangs is fixed
  postFixup = ''
    find $out -type f -print0 | xargs --null sed -i 's|${stdenv.shellPackage}|${runtimeShellPackage}|'
  '';

  meta = {
    description = "A client for the Dynamic Host Configuration Protocol (DHCP)";
    homepage = https://roy.marples.name/projects/dhcpcd;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ eelco fpletz ];
  };
}
