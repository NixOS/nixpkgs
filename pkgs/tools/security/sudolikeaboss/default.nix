{ stdenv, buildGoPackage, fetchFromGitHub, fixDarwinDylibNames, darwin }:
buildGoPackage rec {
  name = "sudolikeaboss-${version}";
  version = "0.2.1";

  goPackagePath = "github.com/ravenac95/sudolikeaboss";
  src = fetchFromGitHub {
    owner = "ravenac95";
    repo = "sudolikeaboss";
    rev = "v${version}";
    sha256 = "1zsmy67d334nax76sq0g2sczp4zi19d94d3xfwgadzk7sxvw1z0m";
  };
  goDeps = ./deps.nix;

  propagatedBuildInputs = with darwin.apple_sdk.frameworks; [
    Cocoa
    fixDarwinDylibNames
  ];

  postInstall = ''
    install_name_tool -delete_rpath $out/lib -add_rpath $bin $bin/bin/sudolikeaboss
  '';

  meta = with stdenv.lib; {
    inherit version;
    inherit (src.meta) homepage;
    description = "Get 1password access from iterm2";
    license = licenses.mit;
    maintainers = [ maintainers.grahamc ];
    platforms = platforms.darwin;
  };

}
