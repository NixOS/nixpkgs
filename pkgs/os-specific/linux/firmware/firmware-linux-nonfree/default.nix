# The firmware bundle as packaged by Debian. This should be "all" firmware that is not shipped
# as part of the kernel itself.
# You can either install the complete bundle, or write a separate package for individual
# devices that copies the firmware from this package.

{ stdenv, fetchurl, buildEnv, dpkg }:

let
  version = "0.35";

  packages = [
    { name = "linux-nonfree"; sha256 = "8c0701500e5252e3e05ad0e5403cc5295899ccb2d6d731380b5f4c2d90003ed1"; }
    { name = "atheros"; sha256 = "df411d76e3d55cb256b0974df16cf18f316c1325f33670fbc9e36abba5aa46c0"; }
    { name = "bnx2"; sha256 = "124e74aa6ce477f7b6a0b5eff3870b0104fd885b4bdfb9977175e75bdb9a7525"; }
    { name = "bnx2x"; sha256 = "4cbcf3422a9aaa6e31704770c724179765dceabd2e6867e24cf47039925e6545"; }
    { name = "brcm80211"; sha256 = "eefba7ba31c018d514ea15878cfd7bca36a65b0df3e9024fc3875a990678a684"; }
    { name = "intelwimax"; sha256 = "436a3bd128224f43988630318aa3e74abfbe838916e1e10a602ddc468b75d843"; }
    { name = "ipw2x00"; sha256 = "9c214e3a9f7f7d710b5cb30282d5ca2b2ccafc3bb208dfe7e18de16d3aadc7a3"; }
    { name = "ivtv"; sha256 = "ced47d8b87ff8ff70a8c32492cc4fb5818860ef018b5c04a4415ab26c9b16300"; }
    { name = "iwlwifi"; sha256 = "5d9615ec128b59cc5834e0261ea74127c0bc64bafabdaef1028a8f1acf611568"; }
    { name = "libertas"; sha256 = "b109fb5c392928ac5495f8ce1d0f41d123b193031f8b548e8b68e9563db37016"; }
    { name = "linux"; sha256 = "8e87f75c120904f2ca5fd9017e4503c23d8705b9ccaeb570374d1747163620ab"; }
    { name = "myricom"; sha256 = "4c9e19d8b2cea97eb05f9d577537dba81aa36ac06c6da9bbed0bfa20434b7acc"; }
    { name = "netxen"; sha256 = "3bd129229cf548a533c79cb55deefa7e4919e09fcc1f655773f4fa5078d81b9b"; }
    { name = "qlogic"; sha256 = "213d098435c657115d2754ef5ead52e64f5fa05be4dcbcb0d5d3ca745376959c"; }
    { name = "ralink"; sha256 = "51f3001ed15ca72bb088297b9e6e4a821ba6250f0ccc8886d77d2f5386a21836"; }
    { name = "realtek"; sha256 = "a6338f5cd8bbe9627fa994016ebb0a91b40914021bec280ddc8f8a56eab22287"; }
  ];

  fetchPackage =
    { name, sha256 }: fetchurl {
      url = "mirror://debian/pool/non-free/f/firmware-nonfree/firmware-${name}_${version}_all.deb";
      inherit sha256;
    };

  srcs = map fetchPackage packages;

in stdenv.mkDerivation {
  name = "firmware-linux-nonfree-${version}";
  inherit srcs;

  unpackPhase = ''
    ensureDir "./firmware"
  '';

  buildPhase = ''
    for src in $srcs; do
      dpkg-deb -W $src
      dpkg-deb -x $src .
    done
  '';

  buildInputs = [ dpkg ];

  installPhase = ''
    ensureDir "$out/"
    cp -r lib/firmware/* "$out/"
  '';

  meta = {
    description = "Binary firmware collection packaged by Debian";
    homepage = "http://packages.debian.org/sid/firmware-linux-nonfree";
    license = "unfree-redistributable-firmware";
    priority = 10; # low priority so that other packages can override this big package
  };
}
