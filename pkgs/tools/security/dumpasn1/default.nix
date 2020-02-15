{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "dumpasn1";
  version = "unstable-2014-06-26";

  hardeningDisable = [ "all" ];

  src = fetchFromGitHub {
    owner = "clibs";
    repo = "dumpasn1";
    rev = "a73ca41a1ec1a44e655e98b627e24f91d8ae2477";
    sha256 = "06bc3qhf137aj5dd1vjxgnfpd41mg00c9qvgfd5dijzrgfl66fa1";
  };

  buildPhase = "gcc ./dumpasn1.c";

  installPhase = ''
    mkdir -p $out/bin
    cp ./a.out $out/bin/dumpasn1
  '';

  meta = with stdenv.lib; {
    description =
      "object dump program that will dump data encoded using any of the ASN.1 encoding rules in a variety of user-specified formats";
    homepage = "https://www.cs.auckland.ac.nz/~pgut001/";
    maintainers = with maintainers; [ btlvr ];
    license = licenses.bsdOriginal;
  };
}
