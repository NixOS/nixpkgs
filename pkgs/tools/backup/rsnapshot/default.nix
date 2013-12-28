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
  name = "rsnapshot-1.3.1";
  src = fetchurl {
    url = "mirror://sourceforge/rsnapshot/${name}.tar.gz";
    sha256 = "0pn7vlg3yxl7xrvfwmp4zlrg3cckmlldq6qr5bs3b2b281zcgdll";
  };

  propagatedBuildInputs = [perl openssh rsync logger];

  patchPhase = ''
    substituteInPlace "Makefile.in" --replace \
      "/usr/bin/pod2man" "${perl}/bin/pod2man"
    patch -p0 <${patch}
  '';

  meta = {
    description = "A filesystem snapshot utility for making backups of local and remote systems";
    homepage = http://rsnapshot.org/;
    license = "GPLv2+";
  };
}
