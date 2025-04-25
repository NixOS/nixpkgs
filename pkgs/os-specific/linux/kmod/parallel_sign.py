import argparse
import multiprocessing
import os
import subprocess

parser = argparse.ArgumentParser()
parser.add_argument('--privKeyPathOrUri', type=str, required=True)
parser.add_argument('--pubKeyPath', type=str, required=True)
parser.add_argument('--hashAlgorithm', type=str, required=True)
parser.add_argument('--buildPath', type=str, required=True)
args = parser.parse_args()

hash_algorithm = getattr(args, 'hashAlgorithm')
priv_key_path_or_uri = getattr(args, 'privKeyPathOrUri')
pubkey_path = getattr(args, 'pubKeyPath')
build_path = getattr(args, 'buildPath')

# adapt this to new compression schemes, when needed
# types of modules (as of kernel 6.14):
#   - uncompressed (.ko)
#   - compressed with gzip (.ko.gz)
#   - compressed with xz (.ko.xz)
#   - compressed with zstd (.ko.zst)
def handle_signing(args):
    global hash_algorithm
    global pubkey_path
    global priv_key_path_or_uri

    dirpath, filename = args

     # track compression
    ext = None

    # need to decompress?
    if filename.endswith(('.ko.xz', '.ko.zst', '.ko.gz')):
        basename = os.path.splitext(filename)[0]
        ext = os.path.splitext(filename)[-1]
        if ext == '.xz':
            subprocess.check_call(f'xz -d "{dirpath}/{filename}"', shell=True)
        if ext == '.zst':
            subprocess.check_call(f'zstd --rm -d "{dirpath}/{filename}"', shell=True)
        if ext == '.gz':
            subprocess.check_call(f'gzip -d "{dirpath}/{filename}"', shell=True)
        filename = basename

    # sign
    print(f"signing {filename}")
    subprocess.check_call(f'sign-file "{hash_algorithm}" "{priv_key_path_or_uri}" "{pubkey_path}" "{dirpath}/{filename}"', shell=True)

    # compress again
    if ext:
        if ext == '.xz':
            subprocess.check_call(f'xz --check=crc32 --lzma2=dict=1MiB -f "{dirpath}/{filename}"', shell=True)
        if ext == '.zst':
            subprocess.check_call(f'zstd -T0 --rm -f -q "{dirpath}/{filename}"', shell=True)
        if ext == '.gz':
            subprocess.check_call(f'gzip -n -f "{dirpath}/{filename}"', shell=True)

jobs = []
for (dirpath, dirnames, filenames) in os.walk(build_path):
    for filename in filenames:
        # early continue for non-modules
        if filename.find(".ko") == -1:
            continue
        
        jobs.append((dirpath, filename))

num_cores = multiprocessing.cpu_count()
with multiprocessing.Pool(num_cores) as p:
    p.map(handle_signing, jobs)
