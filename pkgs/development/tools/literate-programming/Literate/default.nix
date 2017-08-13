{ stdenv, fetchgit, dmd, dub }:

stdenv.mkDerivation {
  name = "Literate";
  src = fetchgit {
    url = "https://github.com/zyedidia/Literate.git";
    rev = "23928d64bb19b5101dbcc794da6119beaf59f679";
    sha256 = "094lramvacarzj8443ns18zyv7dxnivwi7kdk5xi5r2z4gx338iq";
  };
  buildInputs = [dmd dub];
  preInstall = ''
  # Gross, but the Makefile doesn't provide an install target
  mkdir $out
  cp -R bin $out/bin
  '';
  phases = "unpackPhase patchPhase buildPhase checkPhase preInstall fixupPhase";
}
