{ stdenv, fetchgit, curl, jansson, autoconf, automake
, aesni ? true }:

let
  rev = "977dad27e18627e5b723800f5f4201e385fe0d2e";
  date = "20140723";
in
stdenv.mkDerivation rec {
  name = "cpuminer-multi-${date}-${stdenv.lib.strings.substring 0 7 rev}";

  src = fetchgit {
    inherit rev;
    url = https://github.com/wolf9466/cpuminer-multi.git;
    sha256 = "9c438c6cd9f40273822f3d3103a370e43e8a40368695ed5e01ae87297dce7843";
  };

  buildInputs = [ autoconf automake curl jansson ];

  preConfigure = ''
    ./autogen.sh
  '';

  configureFlags = [ (if aesni then "--enable-aes-ni" else "--disable-aes-ni") ];

  meta = with stdenv.lib; {
    description = "Multi-algo CPUMiner";
    homepage = https://github.com/wolf9466/cpuminer-multi;
    license = licenses.gpl2;
    maintainers = [ maintainers.ehmry ];
  };
}