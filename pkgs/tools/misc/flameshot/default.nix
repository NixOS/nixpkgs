{ mkDerivation, lib, fetchFromGitHub, qtbase, qmake, qttools, qtsvg }:

# To use `flameshot gui`, you will also need to put flameshot in `services.dbus.packages`
# in configuration.nix so that the daemon gets launched properly:
#
#   services.dbus.packages = [ pkgs.flameshot ];
#   environment.systemPackages = [ pkgs.flameshot ];
mkDerivation rec {
  pname = "flameshot";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "lupoDharkael";
    repo = "flameshot";
    rev = "v${version}";
    sha256 = "193szslh55v44jzxzx5g9kxhl8p8di7vbcnxlid4acfidhnvgazm";
  };

  nativeBuildInputs = [ qmake qttools qtsvg ];
  buildInputs = [ qtbase ];

  qmakeFlags = [ "PREFIX=${placeholder "out"}" ];

  preConfigure = ''
    # flameshot.pro assumes qmake is being run in a git checkout.
    git() { echo ${version}; }
    export -f git
  '';

  postFixup = ''
    substituteInPlace $out/share/dbus-1/services/org.dharkael.Flameshot.service \
      --replace "/usr/local" "$out"
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Powerful yet simple to use screenshot software";
    homepage = "https://github.com/lupoDharkael/flameshot";
    maintainers = [ maintainers.scode ];
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
  };
}
