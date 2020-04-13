{
  pkgs
, stdenv
, libusb
, fetchFromGitHub
, lib
}:
stdenv.mkDerivation rec {
   pname = "micronucleus";
   version = "2.04";

   sourceRoot = "source/commandline";

   src = fetchFromGitHub {
     owner = "micronucleus";
     repo = "micronucleus";
     rev = version;
     sha256 = "14msy9amlbflw5mqrbs57b7bby3nsgx43srr7215zyhfdgsla0in";
   };

   buildInputs = [ libusb ];
   makeFlags = stdenv.lib.optionals stdenv.isDarwin [ "CC=cc" ];

   installPhase = ''
     mkdir -p $out/bin
     mkdir -p $out/lib/udev
     cp micronucleus $out/bin
     cp 49-micronucleus.rules $out/lib/udev
   '';

   meta = with lib; {
     description = "Upload tool for micronucleus";
     homepage = "https://github.com/micronucleus/micronucleus";
     license = licenses.gpl3;
     maintainers = [ maintainers.cab404 ];
   };

}
