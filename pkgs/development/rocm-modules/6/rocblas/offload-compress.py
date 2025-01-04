# Compress standalone hsaco/co files the way clang-offload-bundler does
# https://clang.llvm.org/docs/ClangOffloadBundler.html#compression-and-decompression
import zstandard as zstd
import struct
import hashlib
import os
import argparse
import glob

# Constants
MAGIC_NUMBER = b'CCOB'
VERSION = 2
COMPRESSION_METHOD_ZSTD = 1  # Assuming 1 represents zstd in the LLVM compression enumeration

def calculate_md5(data):
    return hashlib.md5(data).digest()[:8]  # 64-bit truncated MD5 hash

# struct __ClangOffloadBundleCompressedHeader {
#   const char magic[kOffloadBundleCompressedMagicStrSize - 1];
#   uint16_t versionNumber;
#   uint16_t compressionMethod;
#   uint32_t totalSize;
#   uint32_t uncompressedBinarySize;
#   uint64_t Hash;
#   const char compressedBinarydesc[1];
# };

def compress_file(input_file):
    # Read the input file
    with open(input_file, 'rb') as f:
        uncompressed_data = f.read()

    if uncompressed_data[0:len(MAGIC_NUMBER)] == MAGIC_NUMBER:
        print(f"{input_file} already compressed, skipping")
        return

    # Compress the data
    cctx = zstd.ZstdCompressor()
    compressed_data = cctx.compress(uncompressed_data)

    # Calculate hash
    hash_value = calculate_md5(uncompressed_data)

    # Create header
    header = struct.pack('@4sHHII8s',
                         MAGIC_NUMBER,
                         VERSION,
                         COMPRESSION_METHOD_ZSTD,
                         len(compressed_data) + 24,  # Total file size (header + compressed data)
                         len(uncompressed_data),
                         hash_value)

    # Write compressed file
    with open(input_file, 'wb') as f:
        f.write(header)
        f.write(compressed_data)

def process_directory(directory):
    # Get all .hsaco and .co files in the directory
    files_to_compress = list(glob.glob(os.path.join(directory, '**', '*.hsaco'), recursive=True) + glob.glob(os.path.join(directory, '**', '*.co'), recursive=True))

    successes = 0
    for file in files_to_compress:
        try:
            compress_file(file)
            print(f"Compressed: {file}")
            successes += 1
        except Exception as e:
            print(f"Error compressing {file}: {str(e)}")

    print(f"Compression complete. Compressed {successes: 5d} / {len(files_to_compress): 5d}")

def main():
    parser = argparse.ArgumentParser(description="Compress .hsaco and .co files in a directory using zstd.")
    parser.add_argument("directory", help="Directory containing files to compress")
    args = parser.parse_args()

    if not os.path.isdir(args.directory):
        print(f"Error: {args.directory} is not a valid directory")
        return

    process_directory(args.directory)

if __name__ == '__main__':
    main()
