{ stdenv, fetchurl, nasm }:

let
  arch =
    if      stdenv.system == "x86_64-linux" then "bandwidth64"
    else if stdenv.system == "i686-linux" then "bandwidth32"
    else if stdenv.system == "x86_64-darwin" then "bandwidth-mac64"
    else if stdenv.system == "i686-darwin" then "bandwidth-mac32"
    else if stdenv.system == "i686-cygwin" then "bandwidth-win32"
    else null;
in
stdenv.mkDerivation rec {
  name = "bandwidth-${version}";
  version = "1.2.0";

  src = fetchurl {
    url = "https://mutineer.org/file.php?id=ee10698c6a675ece26f08ddb5e6001323d6305c1&p=bandwidth";
    name = "${name}.tar.gz";
    sha256 = "1jq6a4n77gcx68bkr8l79agsmgv8saw9nv183297gnah1g67nvw6";
  };

  buildInputs = [ nasm ];

  buildFlags = [ arch ]
    ++ stdenv.lib.optionals stdenv.cc.isClang [ "CC=clang" "LD=clang" ];

  installPhase = ''
    mkdir -p $out/bin
    cp ${arch} $out/bin
    ln -s ${arch} $out/bin/bandwidth
  '';

  meta = with stdenv.lib; {
    homepage = https://zsmith.co/bandwidth.html;
    description = "Artificial benchmark for identifying weaknesses in the memory subsystem";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ nckx wkennington ];
  };
}
