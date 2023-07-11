To update discourse, do the following:

1. Switch to and work from the `master` branch and the directory this
   file is in.
2. Run `./update.py print-diffs` and update the nginx settings and
   backend settings accordingly. If you don't know how to, ask for
   help - do not skip this step!
3. Run `./update.py update`.
4. Run `nix build -L -f ../../../../ discourse.tests` to make sure the
   update works. Also test manually, if possible.
5. If the update works, commit it. If not, apply necessary fixes and
   commit. No manual fixes that would be overwritten by the
   `./update.py` script should be committed - the script should be
   fixed instead.
6. Run `./update.py update-mail-receiver`. If there's an update, do
   step 4 and 5 again.
7. Run `./update.py update-plugins`.
8. Run `nix build -L -f ../../../../ discourseAllPlugins.tests` to
   make sure the plugins build and discourse starts with them. Also
   test manually, if possible.
9. If the update works, commit it. If not, apply necessary fixes and
   commit. No manual fixes that would be overwritten by the
   `./update.py` script should be committed - the script should be
   fixed instead.
