{ stdenv, xorg, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "go-sct";
  version = "20180605-${stdenv.lib.strings.substring 0 7 rev}";
  rev = "eb1e851f2d5017038d2b8e3653645c36d3a279f4";

  goPackagePath = "github.com/d4l3k/go-sct";

  src = fetchFromGitHub {
    inherit rev;
    owner = "d4l3k";
    repo = "go-sct";
    sha256 = "16z2ml9x424cnliazyxlw7pm7q64pppjam3dnmq2xab0wlbbm3nm";
  };

  goDeps = ./deps.nix;

  buildInputs = [ xorg.libX11 xorg.libXrandr ];

  meta = with stdenv.lib; {
    description = "Color temperature setting library and CLI that operates in a similar way to f.lux and Redshift";
    license = licenses.mit;
    maintainers = with maintainers; [ rvolosatovs cstrahan ];
    platforms = platforms.linux ++ platforms.windows;
  };
}
