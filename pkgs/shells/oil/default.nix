{ stdenv, lib, fetchurl }:

stdenv.mkDerivation rec {
  pname = "oil";
  version = "0.7.pre5";

  src = fetchurl {
    url = "https://www.oilshell.org/download/oil-${version}.tar.xz";
    sha256 = "1vpk4my8lp7wik8ywspawimya2a7hb1qjkp5vpm7ypmkya5jqivc";
  };

  postPatch = ''
    patchShebangs build
  '';

  preInstall = ''
    mkdir -p $out/bin
  '';

  # Stripping breaks the bundles by removing the zip file from the end.
  dontStrip = true;

  meta = {
    description = "A new unix shell";
    homepage = https://www.oilshell.org/;

    license = with lib.licenses; [
      psfl # Includes a portion of the python interpreter and standard library
      asl20 # Licence for Oil itself
    ];

    maintainers = with lib.maintainers; [ lheckemann ];
  };
}
