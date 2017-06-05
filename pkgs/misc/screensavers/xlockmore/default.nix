{ stdenv, lib, fetchurl, pam ? null, autoreconfHook
, libX11, libXext, libXinerama, libXdmcp, libXt }:

stdenv.mkDerivation rec {

  name = "xlockmore-5.54";
  src = fetchurl {
    url = "http://sillycycle.com/xlock/${name}.tar.xz";
    sha256 = "0mdgl20619iii1i04pj2dq29nwvasbngy48cvd819h0wfawsqkwz";
    curlOpts = "--user-agent 'Mozilla/5.0'";
  };

  # Optionally, it can use GTK+.
  buildInputs = [ pam libX11 libXext libXinerama libXdmcp libXt ];

  nativeBuildInputs = [ autoreconfHook ];

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

  meta = with lib; {
    description = "Screen locker for the X Window System";
    homepage = http://www.tux.org/~bagleyd/xlockmore.html;
    license = licenses.gpl2;
    maintainers = with maintainers; [ pSub ];
    platforms = platforms.linux;
  };
}
