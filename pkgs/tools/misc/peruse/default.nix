{
  kdeDerivation, kdeWrapper, fetchFromGitHub, fetchurl, lib,
  ecm, kdoctools,
  baloo, kconfig, kfilemetadata, kinit, kirigami, plasma-framework
}:

let
  pname = "peruse";
  version = "1.1";
  unarr = fetchFromGitHub {
    owner  = "zeniko";
    repo   = "unarr";
    rev    = "d1be8c43a82a4320306c8e835a86fdb7b2574ca7";
    sha256 = "03ds5da69zipa25rsp76l6xqivrh3wcgygwyqa5x2rgcz3rjnlpr";
  };
  unwrapped = kdeDerivation rec {
    name = "${pname}-${version}";

    src = fetchurl {
      url = "mirror://kde/stable/${pname}/${name}.tar.xz";
      sha256 = "1akk9hg12y6iis0rb5kdkznm3xk7hk04r9ccqyz8lr6y073n5f9j";
    };

    nativeBuildInputs = [ ecm kdoctools ];

    propagatedBuildInputs = [ baloo kconfig kfilemetadata kinit kirigami plasma-framework ];

    preConfigure = ''
      rmdir src/qtquick/karchive-rar/external/unarr
      ln -s ${unarr} src/qtquick/karchive-rar/external/unarr
    '';

    meta = with lib; {
      license = licenses.gpl2;
      maintainers = with maintainers; [ peterhoeg ];
    };

  };

in kdeWrapper {
  inherit unwrapped;
  targets = [ "bin/peruse" ];
}
