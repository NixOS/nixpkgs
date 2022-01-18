{ lib
, stdenv
, fetchFromGitHub
, cmake
, libyamlcpp
, pkg-config
, procps
, coreutils
, smartSupport ? false, libatasmart
}:

stdenv.mkDerivation rec {
  pname = "thinkfan";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "vmatare";
    repo = "thinkfan";
    rev = version;
    sha256 = "sha256-ZCZqi7A4qdWtDSkTw6ktHIZnPhdes2AX7+QBroaDDfI=";
  };

  postPatch = ''
    # fix hardcoded install path
    substituteInPlace CMakeLists.txt --replace /etc $out/etc

    # fix command paths in unit files
    for unit in rcscripts/systemd/*; do
      substituteInPlace "$unit" \
        --replace /bin/kill ${procps}/bin/kill \
        --replace /usr/bin/pkill ${procps}/bin/pkill \
        --replace /usr/bin/sleep ${coreutils}/bin/sleep
    done
  '';

  cmakeFlags = [
    "-DCMAKE_INSTALL_DOCDIR=share/doc/${pname}"
    "-DUSE_NVML=OFF"
    # force install unit files
    "-DSYSTEMD_FOUND=ON"
  ] ++ lib.optional smartSupport "-DUSE_ATASMART=ON";

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [ libyamlcpp ] ++ lib.optional smartSupport libatasmart;

  meta = {
    description = "A simple, lightweight fan control program";
    longDescription = ''
      Thinkfan is a minimalist fan control program. Originally designed
      specifically for IBM/Lenovo Thinkpads, it now supports any kind of
      system via the sysfs hwmon interface (/sys/class/hwmon).
    '';
    license = lib.licenses.gpl3Plus;
    homepage = "https://github.com/vmatare/thinkfan";
    maintainers = with lib.maintainers; [ domenkozar rnhmjoj ];
    platforms = lib.platforms.linux;
  };
}
