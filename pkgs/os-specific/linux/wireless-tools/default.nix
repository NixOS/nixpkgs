{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "wireless-tools-29-pre21";

  src = fetchurl {
    url = http://www.hpl.hp.com/personal/Jean_Tourrilhes/Linux/wireless_tools.29.pre21.tar.gz;
    sha256 = "1agk4i3jvwzdiin7c19ixn8ipi4f2vg71lp3mzcjqmghph9lhwch";
  };

  preBuild = "
    makeFlagsArray=(PREFIX=$out)
  ";
}
