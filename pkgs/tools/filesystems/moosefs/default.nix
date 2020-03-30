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
  version = "3.0.110";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "16m3mxmik2ifrv1g9cp68k57w8xwsxacws3sh1ajlba4azj9sf8v";
  };

  nativeBuildInputs = [ pkgconfig makeWrapper ];

  buildInputs =
    [ fuse libpcap zlib ];

  postInstall = ''
    wrapProgram $out/sbin/mfscgiserv \
        --prefix PATH ":" "${python}/bin"
  '';

  meta = with stdenv.lib; {
    homepage = https://moosefs.com;
    description = "Open Source, Petabyte, Fault-Tolerant, Highly Performing, Scalable Network Distributed File System";
    platforms = platforms.linux;
    license = licenses.gpl2;
    maintainers = [ maintainers.mfossen ];
  };
}
