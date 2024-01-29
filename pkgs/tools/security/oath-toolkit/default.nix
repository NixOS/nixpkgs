{ lib, stdenv, fetchurl, nix-update-script, pam, xmlsec }:

let
  # TODO: Switch to OpenPAM once https://gitlab.com/oath-toolkit/oath-toolkit/-/issues/26 is addressed upstream
  securityDependency =
    if stdenv.isDarwin then xmlsec
    else pam;

in stdenv.mkDerivation rec {
  pname = "oath-toolkit";
  version = "2.6.10";

  src = fetchurl {
    url = "mirror://savannah/${pname}/${pname}-${version}.tar.gz";
    sha256 = "sha256-hsJyJPfW19rUek9r7mX2uIS/W70VxemM8sxpYl2/I5E=";
  };

  buildInputs = [ securityDependency ];

  configureFlags = lib.optionals stdenv.isDarwin [ "--disable-pam" ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Components for building one-time password authentication systems";
    homepage = "https://www.nongnu.org/oath-toolkit/";
    maintainers = with maintainers; [ schnusch ];
    platforms = with platforms; linux ++ darwin;
    mainProgram = "oathtool";
  };
}
