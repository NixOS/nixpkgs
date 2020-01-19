{ stdenv, lib, rpmextract, fetchurl, glibc }:
stdenv.mkDerivation rec {
  pname = "tailscale";
  version = "0.94-236";

  src = fetchurl {
    url = "https://tailscale.com/files/dist/tailscale-relay-${version}.x86_64.rpm";
    sha256 = "b8e7505debba715f1a7c444715fbbbca5a6e3dd6515f35756006fa0daab3b9ea";
  };

  buildInputs = [ glibc ];

  nativeBuildInputs = [ rpmextract ];

  unpackPhase = ''
    rpmextract $src
  '';

  installPhase = let
    libPath = lib.makeLibraryPath [ glibc ];
    ldLinux = "${libPath}/ld-linux-x86-64.so.2";
  in ''
    mkdir -p $out/usr/sbin
    cd usr/sbin
    cp * $out/usr/sbin

    patchelf --set-rpath "${libPath}" $out/usr/sbin/relaynode
    patchelf --set-interpreter "${ldLinux}" $out/usr/sbin/relaynode
    patchelf --set-rpath "${libPath}" $out/usr/sbin/taillogin
    patchelf --set-interpreter "${ldLinux}" $out/usr/sbin/taillogin
  '';

  meta = with stdenv.lib; {
    homepage = "https://www.tailscale.com";
    description = "A mesh VPN that makes it easy to connect your devices, wherever they are";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ danderson ];
  };
}
