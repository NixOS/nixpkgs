{ lib, buildGoPackage, fetchgit }:

buildGoPackage rec {
  pname = "gohai";
  version = "2018-05-23";
  rev = "60e13eaed98afa238ad6dfc98224c04fbb7b19b1";

  goPackagePath = "github.com/DataDog/gohai";

  src = fetchgit {
    inherit rev;
    url    = "https://github.com/DataDog/gohai";
    sha256 = "15hdw195f6ayrmj1nbyfpfswdai1r1z3qjw927mbma7rwql24dkr";
  };

  goDeps = ./deps.nix;

  meta = with lib; {
    description      = "System information collector";
    homepage         = "https://github.com/DataDog/gohai";
    license          = licenses.mit;
    maintainers      = [ maintainers.tazjin ];
    platforms        = platforms.unix;
    repositories.git = "git://github.com/DataDog/gohai.git";

    longDescription = ''
      Gohai is a tool which collects an inventory of system
      information. It is used by the Datadog agent to provide detailed
      system metrics.
    '';
  };
}
