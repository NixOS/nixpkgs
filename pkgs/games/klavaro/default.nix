{ stdenv, fetchurl, makeWrapper, pkgconfig, intltool, curl, gtk3, espeak }:

stdenv.mkDerivation rec {
  name = "klavaro-${version}";
  version = "3.09";

  src = fetchurl {
    url = "mirror://sourceforge/klavaro/${name}.tar.bz2";
    sha256 = "12gml7h45b1w9s318h0d5wxw92h7pgajn2kh57j0ak9saq0yb0wr";
  };

  nativeBuildInputs = [ intltool makeWrapper pkgconfig ];
  buildInputs = [ curl gtk3 ];

  patches = [ (builtins.toFile "format-string" ''
    Index: src/top10.c
    ===================================================================
    diff --git a/src/top10.c b/src/top10.c
    --- a/src/top10.c	(revision 105)
    +++ b/src/top10.c	(working copy)
    @@ -845,7 +845,7 @@
     		curl_easy_setopt (curl, CURLOPT_WRITEDATA, fh);
     		curl_easy_setopt (curl, CURLOPT_SSL_VERIFYPEER, 0L);
     		fail = curl_easy_perform (curl);
    -		if (fail) g_message (curl_easy_strerror (fail));
    +		if (fail) g_message ("error in download: %s", curl_easy_strerror (fail));
     		fclose (fh);
     	}
     	curl_easy_cleanup (curl);
  '') ];

  postPatch = ''
    substituteInPlace src/tutor.c --replace '"espeak ' '"${espeak}/bin/espeak '
  '';

  postInstall = ''
    wrapProgram $out/bin/klavaro \
      --prefix LD_LIBRARY_PATH : $out/lib
  '';

  # Hack to avoid TMPDIR in RPATHs.
  preFixup = ''rm -rf "$(pwd)" '';

  meta = {
    description = "Just another free touch typing tutor program";
    homepage = http://klavaro.sourceforge.net/;
    license = stdenv.lib.licenses.gpl3Plus;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [stdenv.lib.maintainers.mimadrid];
  };
}
