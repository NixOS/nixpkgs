{ stdenv, fetchurl, iodine, intltool, pkgconfig, networkmanager, libsecret
, withGnome ? true, gnome3 }:

let
  pname   = "NetworkManager-iodine";
  version = "1.2.0";
in stdenv.mkDerivation rec {
  name    = "${pname}${if withGnome then "-gnome" else ""}-${version}";

  src = fetchurl {
    url    = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0njdigakidji6mfmbsp8lfi8wl88z1dk8cljbva2w0xazyddbwyh";
  };

  buildInputs = [ iodine networkmanager libsecret ]
    ++ stdenv.lib.optionals withGnome [ gnome3.gtk gnome3.libgnome-keyring
                                        gnome3.networkmanagerapplet ];

  nativeBuildInputs = [ intltool pkgconfig ];

  # Fixes deprecation errors with networkmanager 1.10.2
  NIX_CFLAGS_COMPILE = "-Wno-deprecated-declarations";

  configureFlags = [
    "${if withGnome then "--with-gnome" else "--without-gnome"}"
    "--disable-static"
    "--localstatedir=/" # needed for the management socket under /run/NetworkManager
  ];

  preConfigure = ''
     substituteInPlace "src/nm-iodine-service.c" \
       --replace "/usr/bin/iodine" "${iodine}/bin/iodine"
  '';

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "networkmanager-iodine";
    };
  };

  meta = {
    description = "NetworkManager's iodine plugin";
    inherit (networkmanager.meta) maintainers platforms;
  };
}
