{ lib, stdenv, fetchFromGitHub
, perl, doxygen, plantuml, libtool, gsoap, pkg-config
, canl-c, libkrb5, curl, apr, apacheHttpd, aprutil, zlib
, openssl, libxml2
}:

stdenv.mkDerivation rec {
  pname = "gridsite";
  version = "unstable-2018-12-13";

  src = fetchFromGitHub {
    owner = "CESNET";
    repo = "gridsite";
    rev = "12d6a775570cdb6b405f0f7d40784819a531cc4f";
    sha256 = "sha256-1oAW/rTXynnogvG2ttiBJ1rpgK2t527//qtAMCK27/s";
  };

  postPatch = ''
    patchShebangs src/roffit
  '';

  nativeBuildInputs = [ perl doxygen plantuml libtool gsoap pkg-config ];
  buildInputs = [ canl-c libkrb5 curl apr apacheHttpd aprutil gsoap zlib ];
  propagatedBuildInputs = [ openssl libxml2 ];

  preBuild = ''
    cd src

    # gsoap is built statically in nixpkgs so --static needs to be included in the pkg-config call
    makeFlagsArray+=(
      "GSOAPSSL_LIBS=$(pkg-config gsoapssl --libs --static)"
    )
  '';

  makeFlags = [
    "prefix=$(out)"
    "GSOAPDIR=${gsoap}"
  ];

  postInstall = ''
    moveToOutput sbin "$cgi"
    moveToOutput lib "$lib"
  '';

  outputs = [ "out" "cgi" "lib" "dev" "doc" "man" ];

  meta = with lib; {
    description = "Grid Security for the Web";
    longDescription = ''
      GridSite was originally a web application developed for managing and formatting the content of http://www.gridpp.ac.uk.
      It has since grown into a set of extensions to the Apache web server and a toolkit for Grid credentials, GACL access control lists and HTTP(S) protocol operations.
      Useful tools include the shell utility urlencode, which may be used to url encode any shell variable. This is perfect for shell scripting with curl or wget.
    '';
    homepage = "https://github.com/CESNET/gridsite";
    license = with licenses; [ asl20 bsd3 ];
    maintainers = with maintainers; [ dandellion ];
    platforms = platforms.unix;
  };
}
