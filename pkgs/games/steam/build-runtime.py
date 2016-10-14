#!/usr/bin/env python2
#
# Script to build and install packages into the Steam runtime
# Patched version of https://github.com/ValveSoftware/steam-runtime/blob/master/build-runtime.py

import os
import re
import sys
import subprocess
import argparse
import json

# The top level directory
top = sys.path[0]

def parse_args():
	parser = argparse.ArgumentParser()
	parser.add_argument("-r", "--runtime", help="specify runtime path", default=os.path.join(top,"runtime"))
	parser.add_argument("-i", "--input", help="packages JSON", required=True)
	return parser.parse_args()


def install_deb (basename, deb, dest_dir):
	installtag_dir=os.path.join(dest_dir, "installed")
	if not os.access(installtag_dir, os.W_OK):
		os.makedirs(installtag_dir)

	#
	# Unpack the package into the dest_dir
	#
	os.chdir(top)
	subprocess.check_call(['dpkg-deb', '-x', deb, dest_dir])


#
# Walks through the files in the runtime directory and converts any absolute symlinks
# to their relative equivalent
#
def fix_symlinks ():
	for dir, subdirs, files in os.walk(args.runtime):
		for name in files:
			filepath=os.path.join(dir,name)
			if os.path.islink(filepath):
				target = os.readlink(filepath)
				if os.path.isabs(target):
					#
					# compute the target of the symlink based on the 'root' of the architecture's runtime
					#
					target2 = os.path.join(args.runtime,target[1:])

					#
					# Set the new relative target path
					#
					os.unlink(filepath)
					os.symlink(os.path.relpath(target2,dir), filepath)

#
# Creates the usr/lib/debug/.build-id/xx/xxxxxxxxx.debug symlink tree for all the debug
# symbols
#
def fix_debuglinks ():
	for dir, subdirs, files in os.walk(os.path.join(args.runtime,"usr/lib/debug")):
		if ".build-id" in subdirs:
			subdirs.remove(".build-id")		# don't recurse into .build-id directory we are creating

		for file in files:

			#
			# scrape the output of readelf to find the buildid for this binary
			#
			p = subprocess.Popen(["readelf", '-n', os.path.join(dir,file)], stdout=subprocess.PIPE)
			for line in iter(p.stdout.readline, ""):
				m = re.search('Build ID: (\w{2})(\w+)',line)
				if m:
					linkdir = os.path.join(args.runtime,"usr/lib/debug/.build-id",m.group(1))
					if not os.access(linkdir, os.W_OK):
						os.makedirs(linkdir)
					link = os.path.join(linkdir,m.group(2))
					print "SYMLINKING symbol file %s to %s" % (link, os.path.relpath(os.path.join(dir,file),linkdir))
					if os.path.lexists(link):
						os.unlink(link)
					os.symlink(os.path.relpath(os.path.join(dir,file), linkdir),link)


args = parse_args()


print ("Creating Steam Runtime in %s" % args.runtime)

with open(args.input) as pkgfile:
	pkgs = json.load(pkgfile)
	for pkg in pkgs:
		install_deb(pkg["name"], pkg["source"], args.runtime)

fix_debuglinks()
fix_symlinks()

# vi: set noexpandtab:
