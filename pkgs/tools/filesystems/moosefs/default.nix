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
  version = "3.0.113";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "0h3dhj6lznbkvmkr21w58avl9fa4pgj73fv0lkzcagksyyh5l0n9";
  };

  nativeBuildInputs = [ pkgconfig makeWrapper ];

  buildInputs =
    [ fuse libpcap zlib ];

  postInstall = ''
    substituteInPlace $out/sbin/mfscgiserv --replace "datapath=\"$out" "datapath=\""
    wrapProgram $out/sbin/mfscgiserv \
        --prefix PATH ":" "${python}/bin"
  '';

  meta = with stdenv.lib; {
    homepage = "https://moosefs.com";
    description = "Open Source, Petabyte, Fault-Tolerant, Highly Performing, Scalable Network Distributed File System";
    platforms = platforms.linux;
    license = licenses.gpl2;
    maintainers = [ maintainers.mfossen ];
  };
}
