{ lib, stdenv, fetchFromGitHub, fetchurl, db, openldap }:

let
  inherit (lib) getDev getLib;

  # adtools needs openldap 2.4.x
  openldap' = openldap.overrideAttrs (old: rec {
    version = "2.4.59";
    src = fetchurl {
      url = "https://www.openldap.org/software/download/OpenLDAP/openldap-release/openldap-${version}.tgz";
      hash = "sha256-mfN9Z0fYggbEcAZ+2mJNXkjBAR6UPsCrIXuuhxLiLzQ=";
    };
    buildInputs = old.buildInputs ++ [ db ];
    extraContribModules = [ "passwd/sha2" "passwd/pbkdf2" ];
    # tests are slow and there is not much point in running them when we have pinned this version
    doCheck = false;
    # patchelf gets confused and adds libraries found under /build to RPATH
    preFixup = ''
      rm -r libraries/*/.libs
    '' + old.preFixup;
  });

in
stdenv.mkDerivation (finalAttrs: {
  pname = "adtool";
  version = "1.3.3.20180426";

  src = fetchFromGitHub {
    owner = "blroot";
    repo = "adtool";
    rev = "4159ddec386db9d6545fe5a386686638553bc6af";
    hash = "sha256-LSTn1f/A9rFv7MgmkF+tMFchGNmilDJ6ahj9b4DkHS0=";
  };

  postPatch = ''
    substituteInPlace src/lib/active_directory.c \
      --replace 'AD_CONFIG_FILE SYSCONFDIR "/adtool.cfg"' 'AD_CONFIG_FILE "/etc/adtool.cfg"'
  '';

  configureFlags = [
    "--sysconfdir=/etc"
  ];

  installFlags = [
    "sysconfdir=$(out)/share/doc/${finalAttrs.pname}"
  ];

  buildInputs = [ openldap' ];

  # it expects headers and libraries to exist under the same prefix
  env = {
    NIX_CFLAGS_COMPILE = "-I${getDev openldap'}/include";
    NIX_LDFLAGS = "-L${getLib openldap'}/lib";
  };

  enableParallelBuilding = true;

  # It requires an LDAP server for tests
  doCheck = false;

  meta = with lib; {
    description = "Active Directory administration utility for Unix";
    homepage = "https://gp2x.org/adtool";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ peterhoeg ];
  };
})
