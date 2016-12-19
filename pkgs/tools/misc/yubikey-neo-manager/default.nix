{ stdenv, fetchurl, makeWrapper, python27Packages
, libykneomgr, yubikey-personalization, libu2f-host }:

python27Packages.buildPythonPackage rec {
  namePrefix = "";
  name = "yubikey-neo-manager-${version}";
  version = "1.4.0";
  src = fetchurl {
    url = "https://developers.yubico.com/yubikey-neo-manager/Releases/${name}.tar.gz";
    sha256 = "1isxvx27hk0avxwgwcwys2z8ickfs816ii1aklvmi09ak1rgrf1g";
  };

  propagatedBuildInputs = with python27Packages; [ pyside pycrypto ];
  patches = [ ./fix-pyside-requirement.diff ];

  # aid ctypes load_libary()
  makeWrapperArgs = [
    "--set LD_PRELOAD '${libykneomgr}/lib/libykneomgr.so ${yubikey-personalization}/lib/libykpers-1.so ${libu2f-host}/lib/libu2f-host.so'"
  ];

  meta = with stdenv.lib; {
    homepage = https://developers.yubico.com/yubikey-neo-manager;
    description = "Cross platform personalization tool for the YubiKey NEO";
    license = licenses.bsd2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ mbakke ];
  };
}
