{ lib, stdenv, fetchurl, nix-update-script, pam, xmlsec }:

let
  # TODO: Switch to OpenPAM once https://gitlab.com/oath-toolkit/oath-toolkit/-/issues/26 is addressed upstream
  securityDependency =
    if stdenv.isDarwin then xmlsec
    else pam;

in stdenv.mkDerivation rec {
  pname = "oath-toolkit";
  version = "2.6.7";

  src = fetchurl {
    url = "mirror://savannah/${pname}/${pname}-${version}.tar.gz";
    sha256 = "1aa620k05lsw3l3slkp2mzma40q3p9wginspn9zk8digiz7dzv9n";
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
