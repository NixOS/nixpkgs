{ lib, stdenv, fetchurl, which }:

stdenv.mkDerivation rec {
  pname = "ossec-client";
  version = "2.6";

  src = fetchurl {
    url = "https://www.ossec.net/files/ossec-hids-${version}.tar.gz";
    sha256 = "0k1b59wdv9h50gbyy88qw3cnpdm8hv0nrl0znm92h9a11i5b39ip";
  };

  buildInputs = [ which ];

  patches = [ ./no-root.patch ];

  # Workaround build failure on -fno-common toolchains like upstream
  # gcc-10. Otherwise build fails as:
  #   ld: src/common/mgmt/pint-worker-external.po:(.data.rel.local+0x0): multiple definition of
  #     `PINT_worker_external_impl'; src/common/mgmt/pint-mgmt.po:(.bss+0x20): first defined here
  env.NIX_CFLAGS_COMPILE = "-fcommon";

  buildPhase = ''
    echo "en

agent
$out
no
127.0.0.1
yes
yes
yes


"   | ./install.sh
  '';

  meta = with lib; {
    description = "Open source host-based instrusion detection system";
    homepage = "https://www.ossec.net";
    license = licenses.gpl2;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
  };
}

