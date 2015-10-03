{ stdenv, fetchFromGitHub, nettools }:

let version = "0.4.4"; in
stdenv.mkDerivation {
  name = "hans-${version}";

  src = fetchFromGitHub {
    sha256 = "1xskffmmdmg1whlrl5wpkv9z29vh0igrbmsz0b45s9v0761a7kis";
    rev = "v${version}";
    repo = "hans";
    owner = "friedrich";
  };

  meta = with stdenv.lib; {
    inherit version;
    description = "Tunnel IPv4 over ICMP";
    longDescription = ''
      Hans makes it possible to tunnel IPv4 through ICMP echo packets, so you
      could call it a ping tunnel. This can be useful when you find yourself in
      the situation that your Internet access is firewalled, but pings are
      allowed.
    '';
    homepage = http://code.gerade.org/hans/;
    license = licenses.gpl3Plus;
    platforms = with platforms; linux;
    maintainers = with maintainers; [ nckx ];
  };

  buildInputs = [ nettools ];

  postPatch = ''
    substituteInPlace src/tun.cpp --replace "/sbin/" "${nettools}/bin/"
  '';

  enableParallelBuilding = true;

  installPhase = ''
    install -D -m0755 hans $out/bin/hans
  '';
}
