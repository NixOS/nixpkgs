{ stdenv, fetchurl, makeWrapper, bash, perl, diffstat, diffutils, patch, findutils }:

stdenv.mkDerivation rec {

  name = "quilt-0.66";

  src = fetchurl {
    url = "mirror://savannah/quilt/${name}.tar.gz";
    sha256 = "01vfvk4pqigahx82fhaaffg921ivd3k7rylz1yfvy4zbdyd32jri";
  };

  buildInputs = [ makeWrapper perl bash diffutils patch findutils diffstat ];

  postInstall = ''
    wrapProgram $out/bin/quilt --prefix PATH : \
      ${perl}/bin:${bash}/bin:${diffstat}/bin:${diffutils}/bin:${findutils}/bin:${patch}/bin
  '';

  meta = {
    homepage = https://savannah.nongnu.org/projects/quilt;
    description = "Easily manage large numbers of patches";

    longDescription = ''
      Quilt allows you to easily manage large numbers of
      patches by keeping track of the changes each patch
      makes. Patches can be applied, un-applied, refreshed,
      and more.
    '';

    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.all;
  };

}
