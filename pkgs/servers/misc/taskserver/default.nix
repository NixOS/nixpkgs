{ stdenv, fetchurl, cmake, libuuid, gnutls }:

stdenv.mkDerivation rec {
  name = "taskserver-${version}";
  version = "1.1.0";

  enableParallelBuilding = true;

  src = fetchurl {
    url = "http://www.taskwarrior.org/download/taskd-${version}.tar.gz";
    sha256 = "1d110q9vw8g5syzihxymik7hd27z1592wkpz55kya6lphzk8i13v";
  };

  nativeBuildInputs = [ cmake libuuid ];

  propagatedBuildInputs = [ gnutls ];

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/bin/pki
    mkdir -p $out/share

    cp ../src/taskdctl src/taskd $out/bin/
    cp ../pki/{generate{,.{ca,client,crl,server}},vars} $out/bin/pki/
  '';

  postFixup = ''
    sed -i "s,^\./,$out/bin/pki/," $out/bin/pki/generate
    sed -i "s,\./vars,$out/bin/pki/vars," $out/bin/pki/generate*
  '';

  meta = {
    description = "Server for synchronising Taskwarrior clients";
    homepage = http://taskwarrior.org;
    license = stdenv.lib.licenses.mit;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ matthiasbeyer ];
  };
}
