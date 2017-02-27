{
  kdeDerivation, kdeWrapper, fetchFromGitHub, fetchurl, lib,
  extra-cmake-modules, kdoctools,
  baloo, kconfig, kfilemetadata, kinit, kirigami, knewstuff, plasma-framework
}:

let
  pname = "peruse";
  version = "1.2";
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
      sha256 = "1ik2627xynkichsq9x28rkczqn3l3p06q6vw5jdafdh3hisccmjq";
    };

    nativeBuildInputs = [ extra-cmake-modules kdoctools ];

    propagatedBuildInputs = [ baloo kconfig kfilemetadata kinit kirigami knewstuff plasma-framework ];

    pathsToLink = [ "/etc/xdg/peruse.knsrc"];

    preConfigure = ''
      rm -rf src/qtquick/karchive-rar/external/unarr
      ln -s ${unarr} src/qtquick/karchive-rar/external/unarr
    '';

    meta = with lib; {
      license = licenses.gpl2;
      maintainers = with maintainers; [ peterhoeg ];
    };

  };

in kdeWrapper {
  inherit unwrapped;
  targets = [ "bin/peruse" "bin/perusecreator" ];
}
