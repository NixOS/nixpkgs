{ stdenv, lib, fetchurl }:
let
  version = "0.3.0";
in
stdenv.mkDerivation {
  name = "oil-${version}";

  src = fetchurl {
    url = "https://www.oilshell.org/download/oil-${version}.tar.xz";
    sha256 = "0j4fyn6xjaf29xqyzm09ahazmq9v1hkxv4kps7n3lzdfr32a4kk9";
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
