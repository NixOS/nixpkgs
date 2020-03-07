{ stdenv, fetchFromGitHub
, autoconf, automake, libtool, pkg-config
, bzip2, libpcap, flex, yacc }:

let version = "1.6.19"; in

stdenv.mkDerivation {
  pname = "nfdump";
  inherit version;

  src = fetchFromGitHub {
    owner = "phaag";
    repo = "nfdump";
    rev = "v${version}";
    sha256 = "0idhg7pdkv602h0d0dz7msk8gsxz32ingn16dkqbxp4mgfiakp9r";
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
