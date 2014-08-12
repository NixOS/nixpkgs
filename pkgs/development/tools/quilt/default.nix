{ stdenv, fetchurl, pkgs}:

with pkgs;

stdenv.mkDerivation rec {
  name = "quilt-0.63";

  src = fetchurl {
    url = "mirror://savannah/quilt/${name}.tar.gz";
    sha256 = "2846788221aa8844c54f10239c7cbc5e88031859162bcc285449446c3cfffe52";
  };

  buildInputs = [ makeWrapper perl bash diffutils patch findutils diffstat ];

  postInstall = ''
    wrapProgram $out/bin/quilt --prefix PATH : \
      ${perl}/bin:${bash}/bin:${diffstat}/bin:${diffutils}/bin:${findutils}/bin:${patch}/bin
  '';

  meta = {
    homepage = http://savannah.nongnu.org/projects/quilt;
    description = "Easily manage large numbers of patches";

    longDescription = ''
      Quilt allows you to easily manage large numbers of
      patches by keeping track of the changes each patch
      makes. Patches can be applied, un-applied, refreshed,
      and more.
    '';

    license = "GPLv2+";
  };
}
