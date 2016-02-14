{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation {
  name = "M3D-Linux-2016-01-20";

  src = fetchFromGitHub {
    owner = "donovan6000";
    repo = "M3D-Linux";
    rev = "d0bbb0379c52a88af55740a937edc92af162cdf6";
    sha256 = "0fwzb9mf04bw5wxabh3js7nir60kfq8iz7kcigw6c233aadwg03i";
  };

  installPhase = ''
    install -Dm755 m3d-linux $out/bin/m3d-linux
    install -Dm755 90-m3d-local.rules $out/lib/udev/rules.d/90-m3d-local.rules
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/donovan6000/M3D-Linux;
    description = "A Linux program that can communicate with the Micro 3D printer";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar ];
  };
}
