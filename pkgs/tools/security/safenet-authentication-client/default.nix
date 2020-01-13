{
  autoPatchelfHook,
  dpkg,
  gtk2,
  fetchurl, 
  lib,
  pcsclite,
  stdenv
}:
stdenv.mkDerivation rec {

  pname = "safenet-authentication-client";
  version = "9.0.43-0";

  src = fetchurl {
    url = "https://download.comodo.com/SAC/linux/deb/x64/SafenetAuthenticationClient-${version}_amd64.deb";
    sha256 = "68ca4046bde6469ecf6694f8eda7ea775e0e0cf1e299135e9f2e413ea1e7c7aa";
  };

  unpackPhase = ''
    ${dpkg}/bin/dpkg-deb -x $src .
    find .
  '';

  buildInputs = [
    gtk2
    pcsclite
  ];

  nativeBuildInputs = [
    autoPatchelfHook
  ];


  installPhase = ''
    # Delete usr. It's just symlinks
    rm -r usr/lib
    # Move bin out
    mv usr/bin bin
    mkdir -p $out
    cp -r . $out/
  '';

  meta = with lib; {
    homepage = "https://safenet.gemalto.com/multi-factor-authentication/security-applications/authentication-client-token-management";
    description = "Safenet Authentication Client";
    platforms = [ "x86_64-linux" ];
    license = licenses.unfree;
  };
}
