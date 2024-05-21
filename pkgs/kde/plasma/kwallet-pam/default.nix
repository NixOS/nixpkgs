{
  lib,
  mkKdeDerivation,
  pam,
  libgcrypt,
  socat,
}:
mkKdeDerivation {
  pname = "kwallet-pam";

  postPatch = ''
    sed -i pam_kwallet_init -e "s|socat|${lib.getBin socat}/bin/socat|"
  '';

  extraBuildInputs = [pam libgcrypt];
}
