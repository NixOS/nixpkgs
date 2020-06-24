{ stdenv
, fetchFromGitHub
# buildInputs
, cmake
, git
, pkgconfig
# propagatedBuildInputs
, asio
, catch2
, IOKit
, udev
}:

stdenv.mkDerivation rec {
  pname = "pc-ble-driver";
  version = "4.1.1";

  src = fetchFromGitHub {
    owner = "NordicSemiconductor";
    repo = pname;
    rev = "v${version}";
    sha256 = "1llhkpbdbsq9d91m873vc96bprkgpb5wsm5fgs1qhzdikdhg077q";
  };

  nativeBuildInputs = [
    cmake
    git
    pkgconfig
  ];

  propagatedBuildInputs = [
    asio
    catch2
  ] ++ stdenv.lib.optionals stdenv.isDarwin [
    IOKit
  ] ++ stdenv.lib.optionals stdenv.isLinux [
    udev
  ];

  cmakeFlags = [
    "-DNRF_BLE_DRIVER_VERSION=${version}"
  ];

  meta = with stdenv.lib; {
    description = "Desktop library for Bluetooth low energy development";
    homepage = "https://github.com/NordicSemiconductor/pc-ble-driver";
    platforms = platforms.unix;
    license = licenses.unfreeRedistributable;
    maintainers = [ stdenv.lib.maintainers.siriobalmelli ];
  };
}
