{ fetchgit, stdenv, autoconf, automake, libtool, texinfo
, machHeaders, mig, headersOnly ? true
, cross ? null, gccCross ? null, glibcCross ? null
, buildTarget ? "all", installTarget ? "install" }:

assert (cross != null) -> (gccCross != null);

let
  # Unfortunately we can't use `master@{DATE}', see
  # <http://www.bramschoenmakers.nl/en/node/645>.
  date   = "20100512";
  rev    = "7913beaef3e6a2c4f7f315a8db7a31dbe1f713e0";
  suffix = if headersOnly
           then "-headers"
           else (if buildTarget != "all"
                 then "-minimal"
                 else "");
in
stdenv.mkDerivation ({
  name = "hurd${suffix}-${date}";

  src = fetchgit {
    url = "git://git.sv.gnu.org/hurd/hurd.git";
    sha256 = "bf4f1376b26b0dcdfd23ff9c9b01440f50d032f48946fad6d3861539978f8f4d";
    inherit rev;
  };

  buildInputs = [ autoconf automake libtool texinfo mig ]
    ++ stdenv.lib.optional (gccCross != null) gccCross
    ++ stdenv.lib.optional (glibcCross != null) glibcCross;

  propagatedBuildInputs = [ machHeaders ];

  configureFlags = stdenv.lib.optionals headersOnly [ "--build=i586-pc-gnu" ];

  preConfigure = "autoreconf -vfi";

  patchPhase =
    '' echo "removing \`-o root' from makefiles..."
       for mf in {utils,daemons}/Makefile
       do
         sed -i "$mf" -e's/-o root//g'
       done
    '';

  buildPhase = "make ${buildTarget}";
  installPhase = "make ${installTarget}";

  meta = {
    description = "The GNU Hurd, GNU project's replacement for the Unix kernel";

    longDescription =
      '' The GNU Hurd is the GNU project's replacement for the Unix kernel.
         It is a collection of servers that run on the Mach microkernel to
         implement file systems, network protocols, file access control, and
         other features that are implemented by the Unix kernel or similar
         kernels (such as Linux).
      '';

    license = "GPLv2+";

    homepage = http://www.gnu.org/software/hurd/;

    maintainers = [ stdenv.lib.maintainers.ludo ];
  };
}

//

(if headersOnly
 then { buildPhase = ":"; installPhase = "make install-headers"; }
 else (if (cross != null)
       then {
         crossConfig = cross.config;

         # The `configure' script wants to build executables so tell it where
         # to find `crt1.o' et al.
         LDFLAGS = "-B${glibcCross}/lib";
       }
       else { })))
