{ lib, stdenv, fetchFromGitHub
, autoconf, automake, libtool, pkg-config
, bzip2, libpcap, flex, bison }:

let version = "1.7.0.1"; in

stdenv.mkDerivation {
  pname = "nfdump";
  inherit version;

  src = fetchFromGitHub {
    owner = "phaag";
    repo = "nfdump";
    rev = "v${version}";
    sha256 = "sha256-yD/NFGw38ishqQmKhlnHYodXmJuezI09hxNsyObZ1QE=";
  };

  nativeBuildInputs = [ autoconf automake flex libtool pkg-config bison ];
  buildInputs = [ bzip2 libpcap ];

  preConfigure = ''
    # The script defaults to glibtoolize on darwin, so we pass the correct
    # name explicitly.
    LIBTOOLIZE=libtoolize ./autogen.sh
  '';

  configureFlags = [
    "--enable-nsel"
    "--enable-sflow"
    "--enable-readpcap"
    "--enable-nfpcapd"
  ];

  meta = with lib; {
    description = "Tools for working with netflow data";
    longDescription = ''
      nfdump is a set of tools for working with netflow data.
    '';
    homepage = "https://github.com/phaag/nfdump";
    license = licenses.bsd3;
    maintainers = [ maintainers.takikawa ];
    platforms = platforms.unix;
  };
}
