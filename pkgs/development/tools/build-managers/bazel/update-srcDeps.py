#!/usr/bin/env python3
import sys
import json

if len(sys.argv) == 1:
    print("usage: ./this-script WORKSPACE", file=sys.stderr)
    print("Takes the bazel WORKSPACE file and reads all archives into a json dict (by evaling it as python code)", file=sys.stderr)
    print("Hail Eris.", file=sys.stderr)
    sys.exit(1)

http_archives = []

# just the kw args are the dict { name, sha256, urls … }
def http_archive(**kw):
    http_archives.append(kw)
# like http_file
def http_file(**kw):
    http_archives.append(kw)

# this is inverted from http_archive/http_file and bundles multiple archives
def distdir_tar(**kw):
    for archive_name in kw['archives']:
        http_archives.append({
            "name": archive_name,
            "sha256": kw['sha256'][archive_name],
            "urls": kw['urls'][archive_name]
        })

# stubs for symbols we are not interested in
# might need to be expanded if new bazel releases add symbols to the workspace
def workspace(name): pass
def load(*args): pass
def bind(**kw): pass
def list_source_repository(**kw): pass
def new_local_repository(**kw): pass
def local_repository(**kw): pass
DOC_VERSIONS = []
def stardoc_repositories(**kw): pass
def skydoc_repositories(**kw): pass
def rules_sass_dependencies(**kw): pass
def node_repositories(**kw): pass
def sass_repositories(**kw): pass
def register_execution_platforms(*args): pass
def rbe_autoconfig(*args, **kw): pass
def rules_pkg_dependencies(*args, **kw): pass
def winsdk_configure(*args, **kw): pass
def register_local_rc_exe_toolchains(*args, **kw): pass
def register_toolchains(*args, **kw): pass
def debian_deps(): pass
def grpc_deps(): pass
def grpc_extra_deps(): pass
def bazel_skylib_workspace(): pass

# execute the WORKSPACE like it was python code in this module,
# using all the function stubs from above.
with open(sys.argv[1]) as f:
    exec(f.read())

# transform to a dict with the names as keys
d = { el['name']: el for el in http_archives }

print(json.dumps(d, sort_keys=True, indent=4))
