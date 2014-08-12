{ fetchurl, stdenv }:

stdenv.mkDerivation rec {
  name = "pies-1.2";

  src = fetchurl {
    url = "mirror://gnu/pies/${name}.tar.bz2";
    sha256 = "18w0dbg77i56cx1bwa789w0qi3l4xkkbascxcv2b6gbm0zmjg1g6";
  };

  doCheck = true;

  meta = {
    description = "GNU Pies, a program invocation and execution supervisor";

    longDescription =
      '' The name Pies (pronounced "p-yes") stands for Program Invocation and
         Execution Supervisor.  This utility starts and controls execution of
         external programs, called components.  Each component is a
         stand-alone program, which is executed in the foreground.  Upon
         startup, pies reads the list of components from its configuration
         file, starts them, and remains in the background, controlling their
         execution.  If any of the components terminates, the default action
         of Pies is to restart it.  However, it can also be programmed to
         perform a variety of another actions such as, e.g., sending mail
         notifications to the system administrator, invoking another external
         program, etc.

         Pies can be used for a wide variety of tasks.  Its most obious use
         is to put in backgound a program which normally cannot detach itself
         from the controlling terminal, such as, e.g., minicom.  It can
         launch and control components of some complex system, such as
         Jabberd or MeTA1 (and it offers much more control over them than the
         native utilities).  Finally, it can replace the inetd utility!
      '';

    license = stdenv.lib.licenses.gpl3Plus;

    homepage = http://www.gnu.org/software/pies/;

    platforms = stdenv.lib.platforms.gnu;
    maintainers = [ ];
  };
}
