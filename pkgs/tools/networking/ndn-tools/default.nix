{ lib
, stdenv
, boost
, fetchFromGitHub
, libpcap
, ndn-cxx
, openssl
, pkg-config
, sphinx
, waf
}:

stdenv.mkDerivation rec {
  pname = "ndn-tools";
  version = "22.12";

  src = fetchFromGitHub {
    owner = "named-data";
    repo = pname;
    rev = "ndn-tools-${version}";
    sha256 = "sha256-28sPgo2nq5AhIzZmvDz38echGPzKDzNm2J6iIao4yL8=";
  };

  # Hacky workaround for new pcap-config.
  postPatch = ''
    patch -p1 <<EOF
      --- a/tools/dump/wscript
      +++ b/tools/dump/wscript
      @@ -5 +5 @@
      -    conf.check_cfg(package='libpcap', uselib_store='PCAP',
      +    conf.check_cfg(package="", uselib_store='PCAP',
    EOF
  '';

  nativeBuildInputs = [ pkg-config sphinx waf.hook ];
  buildInputs = [ libpcap ndn-cxx openssl ];

  wafConfigureFlags = [
    "--boost-includes=${boost.dev}/include"
    "--boost-libs=${boost.out}/lib"
    "--with-tests"
  ];

  doCheck = false; # some tests fail because of the sandbox environment
  checkPhase = ''
    runHook preCheck
    build/unit-tests
    runHook postCheck
  '';

  meta = with lib; {
    homepage = "https://named-data.net/";
    description = "Named Data Networking (NDN) Essential Tools";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ bertof ];
  };
}
