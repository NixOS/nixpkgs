{ stdenv, lib, fetchurl, coreutils }:
let
  version = "0.0.0";
in
stdenv.mkDerivation {
  name = "oil-${version}";

  src = fetchurl {
    url = "https://www.oilshell.org/download/oil-${version}.tar.xz";
    sha256 = "1mvyvvzw149piwa7xdl3byyn7h31p4cnrf3w9dxr5qfd9vc4gmsm";
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
    homepage = https://www.oilshell.org/;

    description = "A new unix shell, still in its early stages";

    license = with lib.licenses; [
      psfl # Includes a portion of the python interpreter and standard library
      asl20 # Licence for Oil itself
    ];

    maintainers = with lib.maintainers; [ lheckemann ];
  };
}
