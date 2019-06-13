{ stdenv, fetchFromGitHub, pkgconfig, autoreconfHook
, openssl, libpcap, odp-dpdk, dpdk
}:

stdenv.mkDerivation rec {
  name = "ofp-${version}";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "OpenFastPath";
    repo = "ofp";
    rev = "${version}";
    sha256 = "05902593fycgkwzk5g7wzgk0k40nrrgybplkdka3rqnlj6aydhqf";
  };

  nativeBuildInputs = [ pkgconfig autoreconfHook ];
  buildInputs = [ openssl libpcap odp-dpdk dpdk ];

  dontDisableStatic = true;

  postPatch = ''
    substituteInPlace configure.ac --replace m4_esyscmd m4_esyscmd_s
    substituteInPlace scripts/git_hash.sh --replace /bin/bash ${stdenv.shell}
    echo ${version} > .scmversion
  '';

  configureFlags = [
    "--with-odp=${odp-dpdk}"
    "--with-odp-lib=odp-dpdk"
    "--disable-shared"
  ];

  meta = with stdenv.lib; {
    description = "High performance TCP/IP stack";
    homepage = http://www.openfastpath.org;
    license = licenses.bsd3;
    platforms =  [ "x86_64-linux" ];
    maintainers = [ maintainers.abuibrahim ];
    broken = true;
  };
}
