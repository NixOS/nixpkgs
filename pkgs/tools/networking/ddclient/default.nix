{ lib, fetchFromGitHub, perlPackages, iproute2, perl }:

perlPackages.buildPerlPackage rec {
  pname = "ddclient";
  version = "3.9.1";

  src = fetchFromGitHub {
    owner = "ddclient";
    repo = "ddclient";
    rev = "v${version}";
    sha256 = "0hf377g4j9r9sac75xp17nk2h58mazswz4vkg4g2gl2yyhvzq91w";
  };

  # perl packages by default get devdoc which isn't present
  outputs = [ "out" ];

  buildInputs = with perlPackages; [ IOSocketSSL DigestSHA1 DataValidateIP JSONPP IOSocketInet6 ];

  # Use iproute2 instead of ifconfig
  preConfigure = ''
    touch Makefile.PL
    substituteInPlace ddclient \
      --replace 'in the output of ifconfig' 'in the output of ip addr show' \
      --replace 'ifconfig -a' '${iproute2}/sbin/ip addr show' \
      --replace 'ifconfig $arg' '${iproute2}/sbin/ip addr show $arg' \
      --replace '/usr/bin/perl' '${perl}/bin/perl' # Until we get the patchShebangs fixed (issue #55786) we need to patch this manually
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 ddclient $out/bin/ddclient
    install -Dm644 -t $out/share/doc/ddclient COP* ChangeLog README.* RELEASENOTE

    runHook postInstall
  '';

  # there are no tests distributed with ddclient
  doCheck = false;

  meta = with lib; {
    description = "Client for updating dynamic DNS service entries";
    homepage = "https://ddclient.net/";
    license = licenses.gpl2Plus;
    # Mostly since `iproute` is Linux only.
    platforms = platforms.linux;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
