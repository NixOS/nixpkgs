{ stdenv, lib, fetchurl, pam ? null, libX11, libXext, libXinerama
, libXdmcp, libXt }:

stdenv.mkDerivation rec {
  name = "xlockmore-5.59";

  src = fetchurl {
    url = "http://sillycycle.com/xlock/${name}.tar.xz";
    sha256 = "0lajc5a4lki33b9mzfsi74q4hbivbmhwysp7mib4ivnyxianhaid";
    curlOpts = "--user-agent 'Mozilla/5.0'";
  };

  # Optionally, it can use GTK.
  buildInputs = [ pam libX11 libXext libXinerama libXdmcp libXt ];

  # Don't try to install `xlock' setuid. Password authentication works
  # fine via PAM without super user privileges.
  configureFlags =
    [ "--disable-setuid"
    ] ++ (lib.optional (pam != null) "--enable-pam");

  postPatch =
    let makePath = p: lib.concatMapStringsSep " " (x: x + "/" + p) buildInputs;
        inputs = "${makePath "lib"} ${makePath "include"}";
    in ''
      sed -i 's,\(for ac_dir in\),\1 ${inputs},' configure.ac
      sed -i 's,/usr/,/no-such-dir/,g' configure.ac
      configureFlags+=" --enable-appdefaultdir=$out/share/X11/app-defaults"
    '';

  hardeningDisable = [ "format" ]; # no build output otherwise

  meta = with lib; {
    description = "Screen locker for the X Window System";
    homepage = http://sillycycle.com/xlockmore.html;
    license = licenses.gpl2;
    maintainers = with maintainers; [ pSub ];
    platforms = platforms.linux;
  };
}
