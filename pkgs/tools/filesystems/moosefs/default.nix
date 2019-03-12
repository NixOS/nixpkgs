{ stdenv
, fetchzip
, fetchFromGitHub
, makeWrapper
, python
, fuse
, pkgconfig
, libpcap
, file
, zlib 
}:

stdenv.mkDerivation rec {
  pname = "moosefs";
  version = "3.0.103";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "0pqralv57ci4zwd75hz4pxmd4l9d4nib2mcsvrb6jndxqkaqcvns";
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
