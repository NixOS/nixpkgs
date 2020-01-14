{
  autoPatchelfHook,
  dpkg,
  gtk2,
  fetchurl, 
  lib,
  openssl,
  pcsclite,
  stdenv
}:
stdenv.mkDerivation rec {

  pname = "pcsc-safenet";
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
    openssl
    pcsclite
  ];

  runtimeDependencies = [
    openssl
  ];

  nativeBuildInputs = [
    autoPatchelfHook
  ];


  installPhase = ''
    # Set up for pcsc drivers
    mkdir -p pcsc/drivers
    mv usr/share/eToken/drivers/* pcsc/drivers/
    rm -r usr/share/eToken/drivers
    
    # Move binaries  out
    mv usr/bin bin

    # Move UI to bin
    mv usr/share/SAC/SACUIProcess bin/
    rm -r usr/share/SAC

    mkdir $out
    cp -r {bin,etc,lib,pcsc,usr,var} $out/
  '';

  meta = with lib; {
    homepage = "https://safenet.gemalto.com/multi-factor-authentication/security-applications/authentication-client-token-management";
    description = "Safenet Authentication Client";
    platforms = [ "x86_64-linux" ];
    license = licenses.unfree;
  };
}
