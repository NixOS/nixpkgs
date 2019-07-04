{ stdenv, fetchurl, pkgconfig, udev, runtimeShellPackage, runtimeShell, fetchpatch }:

stdenv.mkDerivation rec {
  # when updating this to >=7, check, see previous reverts:
  # nix-build -A nixos.tests.networking.scripted.macvlan.x86_64-linux nixos/release-combined.nix
  name = "dhcpcd-7.1.1";

  src = fetchurl {
    url = "mirror://roy/dhcpcd/${name}.tar.xz";
    sha256 = "0h94g5nl9bg3x3qaajqaz6izl6mlvyjgp93nifnlfb7r7n3j8yd2";
  };

  patches = [
    (fetchpatch {
        url = "https://roy.marples.name/cgit/dhcpcd.git/patch/?id=8d11b33f6c60e2db257130fa383ba76b6018bcf6";
        name = "CVE-2019-11577.patch";
        sha256 = "1fivwydjr5ijnfbwfrqi65d4qa27nwmqsqc5fhzhfpq7xidslv47";
    })
    (fetchpatch {
        url = "https://roy.marples.name/cgit/dhcpcd.git/patch/?id=7121040790b611ca3fbc400a1bbcd4364ef57233";
        name = "CVE-2019-11578-1.patch";
        sha256 = "01vhdly78sld8cgaxfc441hliqm097lzfc9mlyv6q8c869bi3mk4";
    })
    (fetchpatch {
        url = "https://roy.marples.name/cgit/dhcpcd.git/patch/?id=aee631aadeef4283c8a749c1caf77823304acf5e";
        name = "CVE-2019-11578-2.patch";
        sha256 = "1ar1pmbbh47rd7rz66mdy640iwir4rspqczw2nfx2yjxx3s00j3k";
    })
    (fetchpatch {
        url = "https://roy.marples.name/cgit/dhcpcd.git/patch/?id=cfde89ab66cb4e5957b1c4b68ad6a9449e2784da";
        name = "CVE-2019-11578-3.patch";
        sha256 = "0ibgjhh51fii9wg92nvvy431d3r7nms8anki1h2fjzyqcmidhzm9";
    })
    (fetchpatch {
        url = "https://roy.marples.name/cgit/dhcpcd.git/patch/?id=4b67f6f1038fd4ad5ca7734eaaeba1b2ec4816b8";
        name = "CVE-2019-11579.patch";
        sha256 = "0ir2c2206hxxq33mkp6n8hn254w3idgap2i0fh5h5c4bp6yg286i";
    })
    (fetchpatch {
        url = "https://roy.marples.name/cgit/dhcpcd.git/patch/?id=c1ebeaafeb324bac997984abdcee2d4e8b61a8a8";
        name = "CVE-2019-11766-1.patch";
        sha256 = "0ksph40jmpvlchgriq84yn7lkh84159is6k49sq3m3lv0acdg9w5";
    })
    (fetchpatch {
        url = "https://roy.marples.name/cgit/dhcpcd.git/patch/?id=896ef4a54b0578985e5e1360b141593f1d62837b";
        name = "CVE-2019-11766-2.patch";
        sha256 = "1miycp2drz1g5knhn5kk104amrfjz8nfbk68si8ap1wk755p8xvx";
    })
	];

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

  makeFlags = "PREFIX=\${out}";

  # Hack to make installation succeed.  dhcpcd will still use /var/db
  # at runtime.
  installFlags = "DBDIR=\${TMPDIR}/db SYSCONFDIR=$(out)/etc";

  # Check that the udev plugin got built.
  postInstall = stdenv.lib.optional (udev != null) "[ -e $out/lib/dhcpcd/dev/udev.so ]";

  meta = with stdenv.lib; {
    description = "A client for the Dynamic Host Configuration Protocol (DHCP)";
    homepage = https://roy.marples.name/projects/dhcpcd;
    platforms = platforms.linux;
    license = licenses.bsd2;
    maintainers = with maintainers; [ eelco fpletz ];
  };
}
