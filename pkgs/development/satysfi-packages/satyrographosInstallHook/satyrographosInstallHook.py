#!/usr/bin/env python3

import sys
import sexpdata
import shutil
import os

def parse(data, src_path, out_path):
    if not isinstance(data, list):
        return

    for item in data:
        if not isinstance(item, list) or len(item) <= 0:
            continue
        head = item[0]
        if head == sexpdata.Symbol('version'):
            parse_version(item)
        elif head == sexpdata.Symbol('library'):
            parse_library(item, src_path, out_path)
        elif head == sexpdata.Symbol('libraryDoc'):
            parse_library_doc(item, src_path, out_path)
        else:
            raise Exception('Unsupported item: ' + str(item))

def parse_version(data):
    version = data[1]
    version = str(version)
    if version != '0.0.2':
        raise Exception('Unsupported version: ' + version + ', expected 0.0.2')

def parse_library(data, src_path, out_path):
    if not isinstance(data, list):
        return

    library_name = None
    for item in data:
        if not isinstance(item, list) or len(item) <= 0:
            continue
        head = item[0]
        if head == sexpdata.Symbol('name'):
            library_name = item[1]
        elif head == sexpdata.Symbol('version'):
            pass
        elif head == sexpdata.Symbol('sources'):
            if library_name is None:
                raise Exception('Library name is not defined')
            parse_library_sources(item[1], library_name, src_path, out_path)
        elif head == sexpdata.Symbol('opam'):
            pass
        elif head == sexpdata.Symbol('dependencies'):
            pass
        elif head == sexpdata.Symbol('compatibility'):
            pass
        else:
            raise Exception('Unsupported item: ' + str(item))

def parse_library_sources(data, library_name, src_path, out_path):
    print("parse_library_sources: ", data, library_name, src_path, out_path)
    if not isinstance(data, list):
        return

    for item in data:
        head = item[0]
        if head == sexpdata.Symbol('font'):
            dst = item[1]
            src = item[2]
            dst_dir = out_path + '/dist/fonts/' + library_name + '/'
            os.makedirs(os.path.dirname(dst_dir + dst), exist_ok=True)
            shutil.copy2(src_path + '/' + src, dst_dir + dst)
        elif head == sexpdata.Symbol('fontDir'):
            src = item[1]
            dst_dir = out_path + '/dist/fonts/' + library_name + '/'
            os.makedirs(os.path.dirname(dst_dir), exist_ok=True)
            shutil.copytree(src_path + '/' + src, dst_dir, dirs_exist_ok=True)
        elif head == sexpdata.Symbol('hash'):
            dst = item[1]
            src = item[2]
            dst_dir = out_path + '/dist/hash/'
            os.makedirs(os.path.dirname(dst_dir + dst), exist_ok=True)
            shutil.copy2(src_path + '/' + src, dst_dir + dst)
        elif head == sexpdata.Symbol('md'):
            dst = item[1]
            src = item[2]
            dst_dir = out_path + '/dist/md/' + library_name + '/'
            os.makedirs(os.path.dirname(dst_dir + dst), exist_ok=True)
            shutil.copy2(src_path + '/' + src, dst_dir + dst)
        elif head == sexpdata.Symbol('package'):
            dst = item[1]
            src = item[2]
            dst_dir = out_path + '/dist/packages/' + library_name + '/'
            os.makedirs(os.path.dirname(dst_dir + dst), exist_ok=True)
            shutil.copy2(src_path + '/' + src, dst_dir + dst)
        elif head == sexpdata.Symbol('packageDir'):
            src = item[1]
            dst_dir = out_path + '/dist/packages/' + library_name + '/'
            os.makedirs(os.path.dirname(dst_dir), exist_ok=True)
            shutil.copytree(src_path + '/' + src, dst_dir, dirs_exist_ok=True)
        elif head == sexpdata.Symbol('file'):
            dst = item[1]
            src = item[2]
            dst_dir = out_path + '/dist/'
            os.makedirs(os.path.dirname(dst_dir + dst), exist_ok=True)
            shutil.copy2(src_path + '/' + src, dst_dir + dst)
        else:
            raise Exception('Unsupported item: ' + str(item))

def parse_library_doc(data, src_path, out_path):
    pass

def main():
    src_path = sys.argv[1]
    out_path = sys.argv[2]
    satyristes_path = src_path + '/Satyristes'
    with open(satyristes_path, 'r', encoding='utf-8') as f:
        content = f.read()
        data = sexpdata.loads(f'({content})')
    parse(data, src_path, out_path)

if __name__ == '__main__':
    main()
