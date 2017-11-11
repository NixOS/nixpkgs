import subprocess

def _patchelf(*args):
    p = subprocess.Popen(['patchelf'] + list(args), stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    p.wait()
    if p.returncode == 0:
        return p.communicate()[0].rstrip()
    else:
        return None

class PatchElf(Elf):
    def print_soname(self):
        print(_patchelf('--print-soname', self.bfile) or 'This file does not have a soname.')

    def print_rpath(self):
        print(_patchelf('--print-rpath', self.bfile) or 'This file does not have a runpath.')

    def fix_rpath(self, install_rpath):
        if install_rpath:
            old_rpath = _patchelf('--print-rpath', self.bfile)
            if old_rpath:
                new_rpath = old_rpath + b':' + bytes(install_rpath, 'utf-8')
                if len(old_rpath) < len(new_rpath):
                    if self.verbose:
                        print('Expanding rpath beyond original capacity, setting dontStrip:')
                        print('https://github.com/NixOS/nixpkgs/pull/31228')
                    open('.nix-dont-strip', 'a').close()
            else:
                new_rpath = install_rpath
            _patchelf('--set-rpath', new_rpath, self.bfile)

    def remove_rpath_entry(self):
        _patchelf('--remove-rpath', self.bfile)

Elf = PatchElf
