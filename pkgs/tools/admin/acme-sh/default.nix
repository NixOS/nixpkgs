{ lib
, stdenv
, fetchFromGitHub
, coreutils
, curl
, dnsutils
, gnugrep
, gnused
, iproute2
, makeWrapper
, openssl
, socat
, unixtools
}:

stdenv.mkDerivation rec {
  pname = "acme.sh";
  version = "3.0.4";

  src = fetchFromGitHub {
    owner = "acmesh-official";
    repo = "acme.sh";
    rev = version;
    sha256 = "sha256-PHxL48Gj6CJG4r3LXKQCU0KARmTu7DQrC29oLi7gvU8=";
  };

  nativeBuildInputs = [
    makeWrapper
  ];

  installPhase = let
    binPath = lib.makeBinPath [
      coreutils
      curl
      dnsutils
      gnugrep
      gnused
      openssl
      socat
      (if stdenv.isLinux then iproute2 else unixtools.netstat)
    ];
  in
    ''
    runHook preInstall

    mkdir -p $out $out/bin $out/libexec
    cp -R $src/* $_
    makeWrapper $out/libexec/acme.sh $out/bin/acme.sh \
      --prefix PATH : "${binPath}"

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://acme.sh/";
    description = "A pure Unix shell script implementing ACME client protocol";
    longDescription = ''
      An ACME Shell script: acme.sh

      - An ACME protocol client written purely in Shell (Unix shell) language.
      - Full ACME protocol implementation.
      - Support ECDSA certs
      - Support SAN and wildcard certs
      - Simple, powerful and very easy to use. You only need 3 minutes to learn it.
      - Bash, dash and sh compatible.
      - Purely written in Shell with no dependencies on python.
      - Just one script to issue, renew and install your certificates automatically.
      - DOES NOT require root/sudoer access.
      - Docker ready
      - IPv6 ready
      - Cron job notifications for renewal or error etc.
    '';
    license = licenses.gpl3Only;
    maintainers = teams.serokell.members;
    inherit (coreutils.meta) platforms;
  };
}
