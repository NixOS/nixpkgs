{stdenv, fetchurl, unzip}:

stdenv.mkDerivation {
  name = "ec2-api-tools";
  buildInputs = [unzip];
  src = fetchurl {
    url = http://s3.amazonaws.com/ec2-downloads/ec2-api-tools.zip;
    sha256 = "1d5j3hsa9vswrhan5yf2v6sq3plpfl4lgdvk3wlaw14rdv50cdiv";
  };

  builder = ./builder.sh ;
}
