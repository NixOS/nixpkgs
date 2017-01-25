{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "bash-completion-${version}";
  version = "2.4";

  src = fetchurl {
    url = "https://github.com/scop/bash-completion/releases/download/${version}/${name}.tar.xz";
    sha256 = "1xlhd09sb2w3bw8qaypxgkr0782w082mcbx8zf7yzjgy0996pxy0";
  };

  doCheck = true;

  meta = with stdenv.lib; {
    homepage = https://github.com/scop/bash-completion;
    description = "Programmable completion for the bash shell";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = [ maintainers.peti ];
  };
}
