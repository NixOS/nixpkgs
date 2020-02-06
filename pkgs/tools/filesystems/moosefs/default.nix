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
  version = "3.0.109";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "1pwackc511fzx28w3an5qk738ykhpspvc1063w2hv901f213xjzw";
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
