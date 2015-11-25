# This file is generated from generate-r-packages.R. DO NOT EDIT.
# Execute the following command to update the file.
#
# Rscript generate-r-packages.R irkernel >new && mv new irkernel-packages.nix

{ self, derive }:
let derive2 = derive {};
in with self; {
  IRdisplay = derive2 { name="IRdisplay"; version="0.3"; sha256="0aa7v3x6s9jd5kzwfh4659gm3dqkmadbk40a0jdpm856mf9r5w6s"; depends=[base64enc repr]; };
  IRkernel = derive2 { name="IRkernel"; version="0.5"; sha256="0v9f01j1ysadq2f8d4mpbimrspj7051cncl0rd1n97rb8wlb9rrf"; depends=[digest evaluate IRdisplay jsonlite repr rzmq uuid]; };
  repr = derive2 { name="repr"; version="0.4"; sha256="1mhvslkxr5nkxiijapzm29jpmjnhhjs1v9s84xvhqpxlcav8dsn6"; depends=[]; };
  rzmq = derive2 { name="rzmq"; version="0.7.7"; sha256="0cds9wsbfb7lhgfjjfisv1i3905ny7x3i2wbb1rcih03ba4a1ij3"; depends=[]; };
}
