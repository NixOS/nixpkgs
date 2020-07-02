{ stdenv, lib, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "easypdkprog";
  version = "1.2";

  src = fetchFromGitHub {
    owner = "free-pdk";
    repo = "easy-pdk-programmer-software";
    rev = version;
    sha256 = "06bn86rd57ff567l0ipx38raih0zll3y16lg5fpn7c601a9jldps";
  };

  installPhase = ''
    install -Dm755 -t $out/bin easypdkprog
  '' + lib.optionalString stdenv.isLinux ''
    install -Dm644 -t $out/etc/udev/rules.d Linux_udevrules/70-stm32vcp.rules
  '';

  meta = with lib; {
    description = "Read, write and execute programs on PADAUK microcontroller";
    homepage = "https://github.com/free-pdk/easy-pdk-programmer-software";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ david-sawatzke ];
    platforms = platforms.unix;
  };
}
