import os
import subprocess

import gdb

_objects_without_symbols_loaded = set()

def _new_objfile(event):
	_load(event.new_objfile)

gdb.events.new_objfile.connect(_new_objfile)

def _clear_objfiles(event):
	_objects_without_symbols_loaded.clear()

gdb.events.clear_objfiles.connect(_clear_objfiles)

def _get_debug_file_path(obj):
	try:
		out = subprocess.check_output([
			"objcopy",
			"--dump-section=.nix_debug=/dev/stdout",
			obj.filename,
			"/dev/null",
		], stderr=subprocess.STDOUT)
		if b"File in wrong format" in out:
			# objdump isn't exiting with failure in this case.
			return None
		return str(out).replace(" ", "", 1).rstrip()
	except:
		return None

def _load(obj):
	debugfile = _get_debug_file_path(obj)
	if not debugfile:
		return
	
	try:
		obj.add_separate_debug_file(debugfile)
		gdb.write("Loaded symbols for {}.\n".format(obj.username))
		_objects_without_symbols_loaded.discard(obj)
	except Exception as e:
		_objects_without_symbols_loaded.add(obj)
		gdb.write("Error loading debug symbols: {}\n".format(e))
		gdb.write("From: {}\n".format(debugfile, e))
		gdb.write("For:  {}\n".format(obj.username))
		if not os.path.exists(debugfile):
			gdb.write("The debug file doesn't exists.\n")
			gdb.write("You can download missing debug files with 'nix-download-debug'.\n")

def _download(objs):
	debugfiles = [_get_debug_file_path(obj) for obj in objs]
	subprocess.check_call(["nix-store", "-rk"] + debugfiles)

class CommandNixDownloadDebug(gdb.Command):
	def __init__(self):
		super(CommandNixDownloadDebug, self).__init__("nix-download-debug", gdb.COMMAND_USER)
	
	def invoke(self, arg, from_tty):
		assert not arg
		try:
			_download(_objects_without_symbols_loaded)
		finally:
			for obj in list(_objects_without_symbols_loaded):
				_load(obj)

CommandNixDownloadDebug()
