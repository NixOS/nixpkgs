{ lib
 , buildGoModule
 , fetchFromGitHub
 }:

 buildGoModule rec {
   pname = "goatcounter";
   version = "v2.3.0";

   src = fetchFromGitHub {
     owner = "arp242";
     repo = pname;
     rev = version;
     sha256 = "sha256-LzZNUZDgMFy6CYzfc57YNPJY8O5xROZLSFm85GCZIFM";
   };

   vendorSha256 = "sha256-0nbDxvhs3qA6qbibezJ3H9fgPQh0GHbSHMcMF5OiXMg=";

   modRoot = ".";

   doCheck = false;

   meta = with lib; {
     description = "Easy web analytics. No tracking of personal data.";
     longDescription = ''
         GoatCounter is an open source web analytics platform available as a hosted
         service (free for non-commercial use) or self-hosted app. It aims to offer easy
         to use and meaningful privacy-friendly web analytics as an alternative to
         Google Analytics or Matomo.
     '';
     homepage = "https://github.com/arp242/goatcounter";
     license = licenses.eupl12;
     maintainers = with maintainers; [ hanemile ];
   };
 }
