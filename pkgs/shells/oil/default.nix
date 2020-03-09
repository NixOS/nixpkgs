{ stdenv, lib, fetchurl, fetchpatch, readline }:

stdenv.mkDerivation rec {
  pname = "oil";
  version = "0.7.0";

  src = fetchurl {
    url = "https://www.oilshell.org/download/oil-${version}.tar.xz";
    sha256 = "12c9s462879adb6mwd3fqafk0dnqsm16s18rhym6cmzfzy8v8zm3";
  };

  postPatch = ''
    patchShebangs build
  '';

  preInstall = ''
    mkdir -p $out/bin
  '';

  buildInputs = [ readline ];
  configureFlags = [ "--with-readline" ];

  # Stripping breaks the bundles by removing the zip file from the end.
  dontStrip = true;

  meta = {
    description = "A new unix shell";
    homepage = "https://www.oilshell.org/";

    license = with lib.licenses; [
      psfl # Includes a portion of the python interpreter and standard library
      asl20 # Licence for Oil itself
    ];

    maintainers = with lib.maintainers; [ lheckemann alva ];
  };

  passthru = {
      shellPath = "/bin/osh";
  };
}
