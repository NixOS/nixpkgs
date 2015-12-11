{ fetchurl, stdenv, writeText, perl, openssh, rsync, logger,
  configFile ? "/etc/rsnapshot.conf" }:

let patch = writeText "rsnapshot-config.patch" ''
--- rsnapshot-program.pl	2013-10-05 20:31:08.715991442 +0200
+++ rsnapshot-program.pl	2013-10-05 20:31:42.496193633 +0200
@@ -383,7 +383,7 @@
 	}
 	
 	# set global variable
-	$config_file = $default_config_file;
+	$config_file = '${configFile}';
 }
 
 # accepts no args
'';
in
stdenv.mkDerivation rec {
  name = "rsnapshot-1.4.1";

  src = fetchurl {
    url = "http://rsnapshot.org/downloads/${name}.tar.gz";
    sha256 = "1s28wkpqajgmwi88n3xs3qsa4b7yxd6lkl4zfi0mr06klwli2jpv";
  };

  propagatedBuildInputs = [perl openssh rsync logger];

  patchPhase = ''
    substituteInPlace "Makefile.in" --replace \
      "/usr/bin/pod2man" "${perl}/bin/pod2man"
    patch -p0 <${patch}
  '';

  meta = with stdenv.lib; {
    description = "A filesystem snapshot utility for making backups of local and remote systems";
    homepage = http://rsnapshot.org/;
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
