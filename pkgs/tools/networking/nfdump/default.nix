{ lib
, stdenv
, fetchFromGitHub
, autoconf
, automake
, libtool
, pkg-config
, bzip2
, libpcap
, flex
, bison
}:

stdenv.mkDerivation rec {
  pname = "nfdump";
  version = "1.7.4";

  src = fetchFromGitHub {
    owner = "phaag";
    repo = "nfdump";
    rev =  "refs/tags/v${version}";
    hash = "sha256-3V6n0cAD3EG91gkbB/9kNcJhwpZBY4ovUamyaVWAAcY=";
  };

  nativeBuildInputs = [
    autoconf
    automake
    flex
    libtool
    pkg-config
    bison
  ];

  buildInputs = [
    bzip2
    libpcap
  ];

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
    changelog = "https://github.com/phaag/nfdump/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ takikawa ];
    platforms = platforms.unix;
  };
}
