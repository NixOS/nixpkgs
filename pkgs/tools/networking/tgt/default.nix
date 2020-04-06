{ stdenv, lib, fetchFromGitHub, libxslt, libaio, systemd, perl, perlPackages
, docbook_xsl, coreutils, lsof, rdma-core, makeWrapper, sg3_utils, utillinux
}:

stdenv.mkDerivation rec {
  pname = "tgt";
  version = "1.0.79";

  src = fetchFromGitHub {
    owner = "fujita";
    repo = pname;
    rev = "v${version}";
    sha256 = "18bp7fcpv7879q3ppdxlqj7ayqmlh5zwrkz8gch6rq9lkmmrklrf";
  };

  nativeBuildInputs = [ libxslt docbook_xsl makeWrapper ];

  buildInputs = [ systemd libaio ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "SD_NOTIFY=1"
  ];

  installFlags = [
    "sysconfdir=${placeholder "out"}/etc"
  ];

  preConfigure = ''
    sed -i 's|/usr/bin/||' doc/Makefile
    sed -i 's|/usr/include/libaio.h|${libaio}/include/libaio.h|' usr/Makefile
    sed -i 's|/usr/include/sys/|${stdenv.glibc.dev}/include/sys/|' usr/Makefile
    sed -i 's|/usr/include/linux/|${stdenv.glibc.dev}/include/linux/|' usr/Makefile
  '';

  postInstall = ''
    substituteInPlace $out/sbin/tgt-admin \
      --replace "#!/usr/bin/perl" "#! ${perl}/bin/perl -I${perlPackages.ConfigGeneral}/${perl.libPrefix}"
    wrapProgram $out/sbin/tgt-admin --prefix PATH : \
      ${lib.makeBinPath [ lsof sg3_utils (placeholder "out") ]}

    install -D scripts/tgtd.service $out/etc/systemd/system/tgtd.service
    substituteInPlace $out/etc/systemd/system/tgtd.service \
      --replace "/usr/sbin/tgt" "$out/bin/tgt"

    # See https://bugzilla.redhat.com/show_bug.cgi?id=848942
    sed -i '/ExecStart=/a ExecStartPost=${coreutils}/bin/sleep 5' $out/etc/systemd/system/tgtd.service
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "iSCSI Target daemon with RDMA support";
    homepage = "http://stgt.sourceforge.net/";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ johnazoidberg ];
  };
}
