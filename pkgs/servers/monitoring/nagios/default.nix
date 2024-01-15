{ lib
, stdenv
, fetchFromGitHub
, perl
, php
, gd
, libpng
, openssl
, zlib
, unzip
, nixosTests
, nix-update-script
}:

stdenv.mkDerivation rec {
  pname = "nagios";
  version = "4.5.0";

  src = fetchFromGitHub {
    owner = "NagiosEnterprises";
    repo = "nagioscore";
    rev = "refs/tags/nagios-${version}";
    hash = "sha256-km0vB/bopysS7eejDFDKaonXzTzBonIqiw1T+C2lKiQ=";
  };

  patches = [ ./nagios.patch ];
  nativeBuildInputs = [ unzip ];

  buildInputs = [
    php
    perl
    gd
    libpng
    openssl
    zlib
  ];

  configureFlags = [
    "--localstatedir=/var/lib/nagios"
    "--with-ssl=${openssl.dev}"
    "--with-ssl-inc=${openssl.dev}/include"
    "--with-ssl-lib=${lib.getLib openssl}/lib"
  ];

  buildFlags = [ "all" ];

  # Do not create /var directories
  preInstall = ''
    substituteInPlace Makefile --replace '$(MAKE) install-basic' ""
  '';
  installTargets = "install install-config";
  postInstall = ''
    # don't make default files use hardcoded paths to commands
    sed -i 's@command_line *[^ ]*/\([^/]*\) @command_line \1 @'  $out/etc/objects/commands.cfg
    sed -i 's@/usr/bin/@@g' $out/etc/objects/commands.cfg
    sed -i 's@/bin/@@g' $out/etc/objects/commands.cfg
  '';

  passthru = {
    tests = {
      inherit (nixosTests) nagios;
    };
    updateScript = nix-update-script {
      extraArgs = [ "--version-regex" "nagios-(.*)" ];
    };
  };

  meta = {
    description = "A host, service and network monitoring program";
    homepage = "https://www.nagios.org/";
    changelog = "https://github.com/NagiosEnterprises/nagioscore/blob/nagios-${version}/Changelog";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
    mainProgram = "nagios";
    maintainers = with lib.maintainers; [ immae thoughtpolice relrod anthonyroussel ];
  };
}
