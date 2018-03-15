These are experimental standalone Nixpkgs test. Everything is still 
subject to change. You can `nix-build --no-out-link ./default.nix` to
run all the tests.

While it is certain that the helpers in `./temporary-helpers/` will
change, they show how to provide DBus and fonts to the applications that
need them, as well as how to use fMBT to manipulate the GUIs.

WARNING: everything is still unstable, and _no_ consideration will be
given to any code outside this directory that tries to use the tests,
unless an _explicit_ promise otherwise has been given.
