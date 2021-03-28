{ lib, stdenv
, fetchFromGitHub
, makeWrapper
, python
, fuse
, pkg-config
, libpcap
, zlib
}:

stdenv.mkDerivation rec {
  pname = "moosefs";
  version = "3.0.115";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "0dap9dqwwx8adma6arxg015riqc86cmjv2m44hk0kz7s24h79ipq";
  };

  nativeBuildInputs = [ pkg-config makeWrapper ];

  buildInputs =
    [ fuse libpcap zlib python ];

  postInstall = ''
    substituteInPlace $out/sbin/mfscgiserv --replace "datapath=\"$out" "datapath=\""
  '';

  meta = with lib; {
    homepage = "https://moosefs.com";
    description = "Open Source, Petabyte, Fault-Tolerant, Highly Performing, Scalable Network Distributed File System";
    platforms = platforms.linux;
    license = licenses.gpl2;
    maintainers = [ maintainers.mfossen ];
  };
}
