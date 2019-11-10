{ stdenv, lib, fetchurl, fetchpatch, readline }:

stdenv.mkDerivation rec {
  pname = "oil";
  version = "0.7.pre5";

  src = fetchurl {
    url = "https://www.oilshell.org/download/oil-${version}.tar.xz";
    sha256 = "1vpk4my8lp7wik8ywspawimya2a7hb1qjkp5vpm7ypmkya5jqivc";
  };


  # TODO remove at next bump
  patches = [
    (fetchpatch {
      url = "https://github.com/oilshell/oil/commit/81551d76ae5a8b53179f2472492d0b44f13f84fd.patch";
      sha256 = "0v99cx13ajqmf489vvxkqhqi9pjyc8jn0dgc8wp78gsv9js2k7km";
    })
  ];

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
    homepage = https://www.oilshell.org/;

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
