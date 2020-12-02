{ stdenv
, fetchFromGitHub
, makeWrapper
, python
, fuse
, pkgconfig
, libpcap
, zlib
}:

stdenv.mkDerivation rec {
  pname = "moosefs";
  version = "3.0.114";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "0bilrzzlg599xy21cm7r0xb2sanngr74j3z03xgybcm10kl97i7j";
  };

  nativeBuildInputs = [ pkgconfig makeWrapper ];

  buildInputs =
    [ fuse libpcap zlib python ];

  postInstall = ''
    substituteInPlace $out/sbin/mfscgiserv --replace "datapath=\"$out" "datapath=\""
  '';

  meta = with stdenv.lib; {
    homepage = "https://moosefs.com";
    description = "Open Source, Petabyte, Fault-Tolerant, Highly Performing, Scalable Network Distributed File System";
    platforms = platforms.linux;
    license = licenses.gpl2;
    maintainers = [ maintainers.mfossen ];
  };
}
