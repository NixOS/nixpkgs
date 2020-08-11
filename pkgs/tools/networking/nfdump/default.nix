{ stdenv, fetchFromGitHub
, autoconf, automake, libtool, pkg-config
, bzip2, libpcap, flex, yacc }:

let version = "1.6.21"; in

stdenv.mkDerivation {
  pname = "nfdump";
  inherit version;

  src = fetchFromGitHub {
    owner = "phaag";
    repo = "nfdump";
    rev = "v${version}";
    sha256 = "1ifxnpyzyn8nd6n44pjcw0rwck392nzj1gwa4zzqvvgzj477m6ha";
  };

  nativeBuildInputs = [ autoconf automake flex libtool pkg-config yacc ];
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

  meta = with stdenv.lib; {
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
