{ stdenv, lib, xorg, buildGoPackage, fetchgit, fetchhg, fetchbzr, fetchsvn }:

buildGoPackage rec {
  name = "go-sct-${version}";
  version = "20160529-${stdenv.lib.strings.substring 0 7 rev}";
  rev = "1d6b5e05a0b63bfeac9df55003efec352e1bc19d";

  goPackagePath = "github.com/d4l3k/go-sct";

  src = fetchgit {
    inherit rev;
    url = "https://github.com/d4l3k/go-sct";
    sha256 = "1iqdagrq0j7sqxgsj31skgk73k2rbpbvj41v087af9103wf8h9z7";
  };

  goDeps = ./deps.nix;

  buildInputs = [ xorg.libX11 xorg.libXrandr ];

  meta = with stdenv.lib; {
    description = "Color temperature setting library and CLI that operates in a similar way to f.lux and Redshift";
    license = licenses.mit;
    maintainers = with maintainers; [ cstrahan ];
    platforms = platforms.linux;
  };
}
