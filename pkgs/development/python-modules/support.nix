{ pkgs, python }:

with pkgs.lib;

self: rec {

  inherit python;

  pythonAtLeast = versionAtLeast python.pythonVersion;
  pythonOlder = versionOlder python.pythonVersion;
  isPy26 = python.majorVersion == "2.6";
  isPy27 = python.majorVersion == "2.7";
  isPy33 = python.majorVersion == "3.3";
  isPy34 = python.majorVersion == "3.4";
  isPy35 = python.majorVersion == "3.5";
  isPyPy = python.executable == "pypy";
  isPy3k = strings.substring 0 1 python.majorVersion == "3";

  callPackage = pkgs.newScope self;

  bootstrapped-pip = callPackage ./bootstrapped-pip { };

  buildPythonPackage = makeOverridable (callPackage ./generic {
    inherit bootstrapped-pip;
  });

  buildPythonApplication = args: buildPythonPackage ({namePrefix="";} // args );

  # Unique python version identifier
  pythonName =
    if isPy26 then "python26" else
    if isPy27 then "python27" else
    if isPy33 then "python33" else
    if isPy34 then "python34" else
    if isPy35 then "python35" else
    if isPyPy then "pypy" else "";

  modules = python.modules or {
    readline = null;
    sqlite3 = null;
    curses = null;
    curses_panel = null;
    crypt = null;
  };

  wrapPython = pkgs.makeSetupHook
    { deps = pkgs.makeWrapper;
      substitutions.libPrefix = python.libPrefix;
      substitutions.executable = python.interpreter;
      substitutions.magicalSedExpression = let
        # Looks weird? Of course, it's between single quoted shell strings.
        # NOTE: Order DOES matter here, so single character quotes need to be
        #       at the last position.
        quoteVariants = [ "'\"'''\"'" "\"\"\"" "\"" "'\"'\"'" ]; # hey Vim: ''

        mkStringSkipper = labelNum: quote: let
          label = "q${toString labelNum}";
          isSingle = elem quote [ "\"" "'\"'\"'" ];
          endQuote = if isSingle then "[^\\\\]${quote}" else quote;
        in ''
          /^ *[a-z]?${quote}/ {
            /${quote}${quote}|${quote}.*${endQuote}/{n;br}
            :${label}; n; /^${quote}/{n;br}; /${endQuote}/{n;br}; b${label}
          }
        '';

      in ''
        1 {
          /^#!/!b; :r
          /\\$/{N;br}
          /__future__|^ *(#.*)?$/{n;br}
          ${concatImapStrings mkStringSkipper quoteVariants}
          /^ *[^# ]/i import sys; sys.argv[0] = '"'$(basename "$f")'"'
        }
      '';
    }
   ./generic/wrap.sh;
}
