{ stdenv, fetchgit, curl, jansson, autoconf, automake
, aesni ? true }:

let
  rev = "8393e03089c0abde61bd5d72aba8f926c3d6eca4";
  date = "20160316";
in
stdenv.mkDerivation rec {
  name = "cpuminer-multi-${date}-${stdenv.lib.strings.substring 0 7 rev}";

  src = fetchgit {
    inherit rev;
    url = https://github.com/wolf9466/cpuminer-multi.git;
    sha256 = "11dg4rra4dgfb9x6q85irn0hrkx2lkwyrdpgdh10pag09s3vhy4v";
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
    # does not build on i686 https://github.com/lucasjones/cpuminer-multi/issues/27
    platforms = [ "x86_64-linux" ]; 
  };
}
