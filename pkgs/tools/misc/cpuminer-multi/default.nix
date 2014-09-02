{ stdenv, fetchgit, curl, jansson, autoconf, automake, openssl
, aesni ? true }:

let
  rev = "4230012da5d1cc491976c6f5e45da36db6d9f576";
  date = "20140619";
in
stdenv.mkDerivation rec {
  name = "cpuminer-multi-${date}-${stdenv.lib.strings.substring 0 7 rev}";

  src = fetchgit {
    inherit rev;
    url = https://github.com/wolf9466/cpuminer-multi.git;
    sha256 = "c19a5dd1bfdbbaec3729f61248e858a5d8701424fffe67fdabf8179ced9c110b";
  };

  buildInputs = [ autoconf automake curl jansson openssl ];

  preConfigure = ''
    ./autogen.sh
  '';

  configureFlags = if aesni then [ "--disable-aes-ni" ] else [ ];

  meta = with stdenv.lib; {
    description = "Multi-algo CPUMiner";
    homepage = https://github.com/wolf9466/cpuminer-multi;
    license = licenses.gpl2;
    maintainers = [ maintainers.emery ];
  };
}